vim9script
# commentary.vim - Comment stuff out
# Author: neoharju
# Date: 14th of June, 2026

# Vim9script refactor of tpope/vim-commentary.
# Original: https://www.vim.org/scripts/script.php?script_id=3695


if exists('g:loaded_commentary') == 1 || v:version < 900
  finish
endif
g:loaded_commentary = 1

# ---------------------------------------------------------------------------
# NOTE on design:
#
# The original plugin builds small pieces of regex/replacement text and lets
# :substitute()'s '\=expr' evaluate them, closing over the *calling
# function's* locals (l, r, uncomment, ...). That trick relies on those
# locals living in a name-addressable l: scope.
#
# Compiled `:def` functions in Vim9 do not keep their locals in a
# name-addressable scope (they are optimized into slots), so a dynamically
# eval()'d string - which is exactly what substitute()'s '\=' does - cannot
# see them. Two consequences for this rewrite:
#
#   1. Wherever the original only used '\=' to slice/glue submatch(0) with
#      values already known before calling substitute(), that is rewritten
#      as plain Vim9 string manipulation. No eval, no closure problem, and
#      it is faster (no regex-replacement + eval() round-trip per line).
#
#   2. The one truly stateful case - the nested block-comment digit counter
#      used for delimiters like '/*%s*/' - genuinely needs a value threaded
#      through an eval'd expression. For that narrow case we bridge the
#      value through a script-local variable (s:commentary_uncomment),
#      which *is* name-addressable, instead of a def-local one. The regex
#      itself is untouched from upstream, so behaviour is identical.
# ---------------------------------------------------------------------------

var commentary_uncomment: number = 0

def Surroundings(): list<string>
  var default = substitute(&commentstring, '^$', '%s', '')
  default = substitute(default, '\S\zs%s', ' %s', '')
  default = substitute(default, '%s\ze\S', '%s ', '')
  var format = get(b:, 'commentary_format', default)
  return split(format, '%s', true)
enddef

def StripWhiteSpace(l: string, r: string, text: string): list<string>
  var lft = l
  var rgt = r
  if lft[-1 :] ==# ' ' && stridx(text .. ' ', lft) == -1 && stridx(text, lft[0 : -2]) == 0
    lft = lft[0 : -2]
  endif
  if rgt[0] ==# ' ' && (' ' .. text)[-strlen(rgt) - 1 :] != rgt && text[-strlen(rgt) :] == rgt[1 :]
    rgt = rgt[1 :]
  endif
  return [lft, rgt]
enddef

# Strip the l/r delimiters from the trimmed "core" of a line, preserving
# whatever leading whitespace and trailing padding surrounded that core.
# Native replacement for the original's
#   substitute(line, '\S.*\s\@<!', '\=submatch(0)[strlen(l):-strlen(r)-1]', '')
def StripDelimiters(text: string, l: string, r: string): string
  var core = matchstr(text, '\S.*\s\@<!')
  if core == ''
    return text
  endif
  var stripped = core[strlen(l) : -strlen(r) - 1]
  var idx = stridx(text, core)
  var prefix = idx <= 0 ? '' : text[0 : idx - 1]
  return prefix .. stripped .. text[idx + strlen(core) :]
enddef

# Wrap the trailing-trimmed content of a line with l/r, preserving the
# reference indent (or the line's own indent, if it doesn't match).
# Native replacement for the original's
#   substitute(line, '^\%(refIndent\|\s*\)\zs.*\S\@<=', '\=l.submatch(0).r', '')
def AddDelimiters(text: string, l: string, r: string, refIndent: string): string
  var prefix: string
  if refIndent == '' || (strlen(text) >= strlen(refIndent) && text[0 : strlen(refIndent) - 1] ==# refIndent)
    prefix = refIndent
  else
    prefix = matchstr(text, '^\s*')
  endif
  var core = matchstr(text[strlen(prefix) :], '.*\S\@<=')
  if core == ''
    return text
  endif
  return prefix .. l .. core .. r
enddef

# For delimiters whose right side is longer than 2 chars and contains no
# backslash (e.g. '/*' '*/'), tag/untag literal nested occurrences of the
# delimiter already present in the line with a depth counter, so repeated
# (un)commenting of already-nested block comments round-trips correctly.
# This is a straight port of upstream's regex; only the eval closure is
# rerouted through a script-local variable (see NOTE above).
def AdjustNestedDelimiters(text: string, l: string, r: string, uncomment: number): string
  if strlen(r) <= 2 || l .. r =~# '\\'
    return text
  endif
  commentary_uncomment = uncomment
  const pattern = '\M' ..
        \ substitute(l, '\ze\S\s*$', '\\zs\\d\\*\\ze', '') ..
        \ '\|' ..
        \ substitute(r, '\S\zs', '\\zs\\d\\*\\ze', '')
  return substitute(text, pattern,
        \ '\=substitute(string(str2nr(submatch(0)) + 1 - commentary_uncomment), "^0$\\|^-\\d*$", "", "")', 'g')
enddef

def Go(...args: list<any>): string
  var lnum1: number
  var lnum2: number
  if len(args) == 0
    &operatorfunc = Go
    return 'g@'
  elseif len(args) > 1
    lnum1 = args[0]
    lnum2 = args[1]
  else
    lnum1 = line("'[")
    lnum2 = line("']")
  endif

  var [l, r] = Surroundings()
  var uncomment = 2
  var forceUncomment = len(args) > 2 && !!args[2]

  for lnum in range(lnum1, lnum2)
    var text = matchstr(getline(lnum), '\S.*\s\@<!')
    [l, r] = StripWhiteSpace(l, r, text)
    if len(text) > 0 && (stridx(text, l) != 0 || text[strlen(text) - strlen(r) : -1] != r)
      uncomment = 0
    endif
  endfor

  var refIndent = get(b:, 'commentary_startofline', 0) != 0 ? '' : matchstr(getline(lnum1), '^\s*')

  var lines: list<string> = []
  for lnum in range(lnum1, lnum2)
    var text = getline(lnum)
    text = AdjustNestedDelimiters(text, l, r, uncomment)
    if forceUncomment
      if text =~ '^\s*' .. l
        text = StripDelimiters(text, l, r)
      endif
    elseif uncomment != 0
      text = StripDelimiters(text, l, r)
    else
      text = AddDelimiters(text, l, r, refIndent)
    endif
    add(lines, text)
  endfor
  setline(lnum1, lines)

  var modelines = &modelines
  try
    &modelines = 0
    silent doautocmd User CommentaryPost
  finally
    &modelines = modelines
  endtry
  return ''
enddef

def TextObject(inner: bool)
  var [l, r] = Surroundings()
  var lnums = [line('.') + 1, line('.') - 2]
  for [index, dir, bound] in [[0, -1, 1], [1, 1, line('$')]]
    var text = ''
    while (lnums[index] != bound && text ==# '') || !(stridx(text, l) != 0 || text[strlen(text) - strlen(r) : -1] != r)
      lnums[index] += dir
      text = matchstr(getline(lnums[index] + dir), '\S.*\s\@<!')
      [l, r] = StripWhiteSpace(l, r, text)
    endwhile
  endfor
  while (inner || lnums[1] != line('$')) && getline(lnums[0]) == ''
    lnums[0] += 1
  endwhile
  while inner && getline(lnums[1]) == ''
    lnums[1] -= 1
  endwhile
  if lnums[0] <= lnums[1]
    execute 'normal! ' .. lnums[0] .. 'GV' .. lnums[1] .. 'G'
  endif
enddef

command! -range -bar -bang Commentary call <SID>Go(<line1>, <line2>, <bang>0)

xnoremap <expr>   <Plug>Commentary     <SID>Go()
nnoremap <expr>   <Plug>Commentary     <SID>Go()
nnoremap <expr>   <Plug>CommentaryLine <SID>Go() .. '_'
onoremap <silent> <Plug>Commentary        :<C-U>call <SID>TextObject(get(v:, 'operator', '') ==# 'c')<CR>
nnoremap <silent> <Plug>ChangeCommentary c:<C-U>call <SID>TextObject(1)<CR>

if !hasmapto('<Plug>Commentary') || maparg('gc', 'n') ==# ''
  xmap gc  <Plug>Commentary
  nmap gc  <Plug>Commentary
  omap gc  <Plug>Commentary
  nmap gcc <Plug>CommentaryLine
  nmap gcu <Plug>Commentary<Plug>Commentary
endif

nmap <silent> <Plug>CommentaryUndo :echoerr "Change your <Plug>CommentaryUndo map to <Plug>Commentary<Plug>Commentary"<CR>

# vim:set et sw=2:
