""" Borked from: https://github.com/dracula/vim
""" LICENSE: MIT
" Dracula Theme: {{{
"
" https://github.com/dracula/dracula-theme
"
" Copyright 2016, All rights reserved
"
" Code licensed under the MIT license
" http://zenorocha.mit-license.org
"
" @author Trevor Heins <@heinst>
" @author Éverton Ribeiro <nuxlli@gmail.com>
" @author Derek Sifford <dereksifford@gmail.com>
" @author Zeno Rocha <hi@zenorocha.com>
scriptencoding utf8
" }}}


" Palette: {{{

let g:dracula#palette           = {}
let g:dracula#palette.fg        = ['#F8F8F2', 253]

let g:dracula#palette.bglighter = ['#424450', 238]
let g:dracula#palette.bglight   = ['#343746', 237]
let g:dracula#palette.bg        = ['#282A36', 236]
let g:dracula#palette.bgdark    = ['#21222C', 235]
let g:dracula#palette.bgdarker  = ['#191A21', 234]

let g:dracula#palette.comment   = ['#6272A4',  61]
let g:dracula#palette.selection = ['#44475A', 239]
let g:dracula#palette.subtle    = ['#424450', 238]

let g:dracula#palette.cyan      = ['#8BE9FD', 117]
let g:dracula#palette.green     = ['#50FA7B',  84]
let g:dracula#palette.orange    = ['#FFB86C', 215]
let g:dracula#palette.pink      = ['#FF79C6', 212]
let g:dracula#palette.purple    = ['#BD93F9', 141]
let g:dracula#palette.red       = ['#FF5555', 203]
let g:dracula#palette.yellow    = ['#F1FA8C', 228]

"
" ANSI
"
let g:dracula#palette.color_0  = '#21222C'
let g:dracula#palette.color_1  = '#FF5555'
let g:dracula#palette.color_2  = '#50FA7B'
let g:dracula#palette.color_3  = '#F1FA8C'
let g:dracula#palette.color_4  = '#BD93F9'
let g:dracula#palette.color_5  = '#FF79C6'
let g:dracula#palette.color_6  = '#8BE9FD'
let g:dracula#palette.color_7  = '#F8F8F2'
let g:dracula#palette.color_8  = '#6272A4'
let g:dracula#palette.color_9  = '#FF6E6E'
let g:dracula#palette.color_10 = '#69FF94'
let g:dracula#palette.color_11 = '#FFFFA5'
let g:dracula#palette.color_12 = '#D6ACFF'
let g:dracula#palette.color_13 = '#FF92DF'
let g:dracula#palette.color_14 = '#A4FFFF'
let g:dracula#palette.color_15 = '#FFFFFF'

" }}}

" Configuration: {{{

if v:version > 580
  highlight clear
  if exists('syntax_on')
    syntax reset
  endif
endif

let g:colors_name = 'dracula'

if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  finish
endif

" Palette: {{{2

let s:fg        = g:dracula#palette.fg

let s:bglighter = g:dracula#palette.bglighter
let s:bglight   = g:dracula#palette.bglight
let s:bg        = g:dracula#palette.bg
let s:bgdark    = g:dracula#palette.bgdark
let s:bgdarker  = g:dracula#palette.bgdarker

let s:comment   = g:dracula#palette.comment
let s:selection = g:dracula#palette.selection
let s:subtle    = g:dracula#palette.subtle

let s:cyan      = g:dracula#palette.cyan
let s:green     = g:dracula#palette.green
let s:orange    = g:dracula#palette.orange
let s:pink      = g:dracula#palette.pink
let s:purple    = g:dracula#palette.purple
let s:red       = g:dracula#palette.red
let s:yellow    = g:dracula#palette.yellow

let s:none      = ['NONE', 'NONE']


if has('terminal')
  let g:terminal_ansi_colors = []
  for s:i in range(16)
    call add(g:terminal_ansi_colors, g:dracula#palette['color_' . s:i])
  endfor
endif

" }}}2
" User Configuration: {{{2

if !exists('g:dracula_bold')
  let g:dracula_bold = 1
endif

if !exists('g:dracula_italic')
  let g:dracula_italic = 1
endif

if !exists('g:dracula_strikethrough')
  let g:dracula_strikethrough = 1
endif

if !exists('g:dracula_underline')
  let g:dracula_underline = 1
endif

if !exists('g:dracula_undercurl')
  let g:dracula_undercurl = g:dracula_underline
endif

if !exists('g:dracula_full_special_attrs_support')
  let g:dracula_full_special_attrs_support = has('gui_running')
endif

if !exists('g:dracula_inverse')
  let g:dracula_inverse = 1
endif

if !exists('g:dracula_colorterm')
  let g:dracula_colorterm = 1
endif

if !exists('g:dracula_high_contrast_diff')
  let g:dracula_high_contrast_diff = 0
endif

"}}}2
" Script Helpers: {{{2

let s:attrs = {
      \ 'bold': g:dracula_bold == 1 ? 'bold' : 0,
      \ 'italic': g:dracula_italic == 1 ? 'italic' : 0,
      \ 'strikethrough': g:dracula_strikethrough == 1 ? 'strikethrough' : 0,
      \ 'underline': g:dracula_underline == 1 ? 'underline' : 0,
      \ 'undercurl': g:dracula_undercurl == 1 ? 'undercurl' : 0,
      \ 'inverse': g:dracula_inverse == 1 ? 'inverse' : 0,
      \}

function! s:h(scope, fg, ...) " bg, attr_list, special
  let l:fg = copy(a:fg)
  let l:bg = get(a:, 1, ['NONE', 'NONE'])

  let l:attr_list = filter(get(a:, 2, ['NONE']), 'type(v:val) == 1')
  let l:attrs = len(l:attr_list) > 0 ? join(l:attr_list, ',') : 'NONE'

  " If the UI does not have full support for special attributes (like underline and
  " undercurl) and the highlight does not explicitly set the foreground color,
  " make the foreground the same as the attribute color to ensure the user will
  " get some highlight if the attribute is not supported. The default behavior
  " is to assume that terminals do not have full support, but the user can set
  " the global variable `g:dracula_full_special_attrs_support` explicitly if the
  " default behavior is not desirable.
  let l:special = get(a:, 3, ['NONE', 'NONE'])
  if l:special[0] !=# 'NONE' && l:fg[0] ==# 'NONE' && !g:dracula_full_special_attrs_support
    let l:fg[0] = l:special[0]
    let l:fg[1] = l:special[1]
  endif

  let l:hl_string = [
        \ 'highlight', a:scope,
        \ 'guifg=' . l:fg[0], 'ctermfg=' . l:fg[1],
        \ 'guibg=' . l:bg[0], 'ctermbg=' . l:bg[1],
        \ 'gui=' . l:attrs, 'cterm=' . l:attrs,
        \ 'guisp=' . l:special[0],
        \]

  execute join(l:hl_string, ' ')
endfunction

"}}}2
" Dracula Highlight Groups: {{{2

call s:h('DraculaBgLight', s:none, s:bglight)
call s:h('DraculaBgLighter', s:none, s:bglighter)
call s:h('DraculaBgDark', s:none, s:bgdark)
call s:h('DraculaBgDarker', s:none, s:bgdarker)

call s:h('DraculaFg', s:fg)
call s:h('DraculaFgUnderline', s:fg, s:none, [s:attrs.underline])
call s:h('DraculaFgBold', s:fg, s:none, [s:attrs.bold])
call s:h('DraculaFgStrikethrough', s:fg, s:none, [s:attrs.strikethrough])

call s:h('DraculaComment', s:comment)
call s:h('DraculaCommentBold', s:comment, s:none, [s:attrs.bold])

call s:h('DraculaSelection', s:none, s:selection)

call s:h('DraculaSubtle', s:subtle)

call s:h('DraculaCyan', s:cyan)
call s:h('DraculaCyanItalic', s:cyan, s:none, [s:attrs.italic])
call s:h('DraculaCyanInverse', s:cyan, s:bg, [s:attrs.inverse])

call s:h('DraculaGreen', s:green)
call s:h('DraculaGreenBold', s:green, s:none, [s:attrs.bold])
call s:h('DraculaGreenItalic', s:green, s:none, [s:attrs.italic])
call s:h('DraculaGreenItalicUnderline', s:green, s:none, [s:attrs.italic, s:attrs.underline])
call s:h('DraculaGreenInverse', s:green, s:bg, [s:attrs.inverse])

call s:h('DraculaOrange', s:orange)
call s:h('DraculaOrangeBold', s:orange, s:none, [s:attrs.bold])
call s:h('DraculaOrangeItalic', s:orange, s:none, [s:attrs.italic])
call s:h('DraculaOrangeBoldItalic', s:orange, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('DraculaOrangeInverse', s:orange, s:bg, [s:attrs.inverse])

call s:h('DraculaPink', s:pink)
call s:h('DraculaPinkItalic', s:pink, s:none, [s:attrs.italic])
call s:h('DraculaPinkInverse', s:pink, s:bg, [s:attrs.inverse])

call s:h('DraculaPurple', s:purple)
call s:h('DraculaPurpleBold', s:purple, s:none, [s:attrs.bold])
call s:h('DraculaPurpleItalic', s:purple, s:none, [s:attrs.italic])
call s:h('DraculaPurpleInverse', s:purple, s:bg, [s:attrs.inverse])

call s:h('DraculaRed', s:red)
call s:h('DraculaRedInverse', s:red, s:bg, [s:attrs.inverse])

call s:h('DraculaYellow', s:yellow)
call s:h('DraculaYellowItalic', s:yellow, s:none, [s:attrs.italic])
call s:h('DraculaYellowInverse', s:yellow, s:bg, [s:attrs.inverse])

call s:h('DraculaError', s:red, s:none, [], s:red)

call s:h('DraculaErrorLine', s:none, s:none, [s:attrs.undercurl], s:red)
call s:h('DraculaWarnLine', s:none, s:none, [s:attrs.undercurl], s:orange)
call s:h('DraculaInfoLine', s:none, s:none, [s:attrs.undercurl], s:cyan)

call s:h('DraculaTodo', s:cyan, s:none, [s:attrs.bold, s:attrs.inverse])
call s:h('DraculaBoundary', s:comment, s:bgdark)
call s:h('DraculaWinSeparator', s:comment, s:bgdark)
call s:h('DraculaLink', s:cyan, s:none, [s:attrs.underline])

if g:dracula_high_contrast_diff
  call s:h('DraculaDiffChange', s:yellow, s:purple)
  call s:h('DraculaDiffDelete', s:bgdark, s:red)
else
  call s:h('DraculaDiffChange', s:orange, s:none)
  call s:h('DraculaDiffDelete', s:red, s:bgdark)
endif

call s:h('DraculaDiffText', s:bg, s:orange)
call s:h('DraculaInlayHint', s:comment, s:bgdark)

" }}}2

" }}}
" User Interface: {{{

set background=dark

" Required as some plugins will overwrite
call s:h('Normal', s:fg, g:dracula_colorterm || has('gui_running') ? s:bg : s:none )
call s:h('StatusLine', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineNC', s:none, s:bglight)
call s:h('StatusLineTerm', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineTermNC', s:none, s:bglight)
call s:h('WildMenu', s:bg, s:purple, [s:attrs.bold])
call s:h('CursorLine', s:none, s:subtle)

" Maintain the DraculaSearch group for backwards compatibility.
hi! link DraculaSearch DraculaGreenInverse

hi! link ColorColumn  DraculaBgDark
hi! link CursorColumn CursorLine
hi! link CursorLineNr DraculaYellow
hi! link DiffAdd      DraculaGreen
hi! link DiffAdded    DiffAdd
hi! link DiffChange   DraculaDiffChange
hi! link DiffDelete   DraculaDiffDelete
hi! link DiffRemoved  DiffDelete
hi! link DiffText     DraculaDiffText
hi! link Directory    DraculaPurpleBold
hi! link ErrorMsg     DraculaRedInverse
hi! link FoldColumn   DraculaSubtle
hi! link Folded       DraculaBoundary
hi! link IncSearch    DraculaOrangeInverse
call s:h('LineNr', s:comment)
hi! link MoreMsg      DraculaFgBold
hi! link NonText      DraculaSubtle
hi! link Pmenu        DraculaBgDark
hi! link PmenuSbar    DraculaBgDark
hi! link PmenuSel     DraculaSelection
hi! link PmenuThumb   DraculaSelection
call s:h('PmenuMatch', s:cyan, s:bgdark)
call s:h('PmenuMatchSel', s:cyan, s:selection)
hi! link Question     DraculaFgBold
hi! link Search       DraculaSearch
call s:h('SignColumn', s:comment)
hi! link TabLine      DraculaBoundary
hi! link TabLineFill  DraculaBgDark
hi! link TabLineSel   Normal
hi! link Title        DraculaGreenBold
hi! link VertSplit    DraculaWinSeparator
hi! link Visual       DraculaSelection
hi! link VisualNOS    Visual
hi! link WarningMsg   DraculaOrangeInverse

" }}}
" Syntax: {{{

" Required as some plugins will overwrite
call s:h('MatchParen', s:green, s:none, [s:attrs.underline])
call s:h('Conceal', s:cyan, s:none)


hi! link Comment DraculaComment
hi! link Underlined DraculaFgUnderline
hi! link Todo DraculaTodo

hi! link Added DiffAdded
hi! link Changed DiffChange
hi! link Removed DiffRemoved

hi! link Error DraculaError
hi! link SpellBad DraculaErrorLine
hi! link SpellLocal DraculaWarnLine
hi! link SpellCap DraculaInfoLine
hi! link SpellRare DraculaInfoLine

hi! link Constant DraculaPurple
hi! link String DraculaYellow
hi! link Character DraculaPink
hi! link Number Constant
hi! link Boolean Constant
hi! link Float Constant

hi! link Identifier DraculaFg
hi! link Function DraculaGreen

hi! link Statement DraculaPink
hi! link Conditional DraculaPink
hi! link Repeat DraculaPink
hi! link Label DraculaPink
hi! link Operator DraculaPink
hi! link Keyword DraculaPink
hi! link Exception DraculaPink

hi! link PreProc DraculaPink
hi! link Include DraculaPink
hi! link Define DraculaPink
hi! link Macro DraculaPink
hi! link PreCondit DraculaPink
hi! link StorageClass DraculaPink
hi! link Structure DraculaPink
hi! link Typedef DraculaPink

hi! link Type DraculaCyanItalic

hi! link Delimiter DraculaFg

hi! link Special DraculaPink
hi! link SpecialComment DraculaCyanItalic
hi! link Tag DraculaCyan
hi! link helpHyperTextJump DraculaLink
hi! link helpCommand DraculaPurple
hi! link helpExample DraculaGreen
hi! link helpBacktick Special

" }}}

" Languages: {{{

" CSS: {{{
hi! link cssAttrComma         Delimiter
hi! link cssAttrRegion        DraculaPink
hi! link cssAttributeSelector DraculaGreenItalic
hi! link cssBraces            Delimiter
hi! link cssFunctionComma     Delimiter
hi! link cssNoise             DraculaPink
hi! link cssProp              DraculaCyan
hi! link cssPseudoClass       DraculaPink
hi! link cssPseudoClassId     DraculaGreenItalic
hi! link cssUnitDecorators    DraculaPink
hi! link cssVendor            DraculaGreenItalic
" }}}

" Git Commit: {{{
" The following two are misnomers. Colors are correct.
hi! link diffFile    DraculaGreen
hi! link diffNewFile DraculaRed

hi! link diffAdded   DraculaGreen
hi! link diffLine    DraculaCyanItalic
hi! link diffRemoved DraculaRed
" }}}

" HTML: {{{
hi! link htmlTag         DraculaFg
hi! link htmlArg         DraculaGreenItalic
hi! link htmlTitle       DraculaFg
hi! link htmlH1          DraculaFg
hi! link htmlSpecialChar DraculaPurple
" }}}

" JavaScript: {{{
hi! link javaScriptBraces   Delimiter
hi! link javaScriptNumber   Constant
hi! link javaScriptNull     Constant
hi! link javaScriptFunction Keyword

" pangloss/vim-javascript
hi! link jsArrowFunction           Operator
hi! link jsBuiltins                DraculaCyan
hi! link jsClassDefinition         DraculaCyan
hi! link jsClassMethodType         Keyword
hi! link jsDestructuringAssignment DraculaOrangeItalic
hi! link jsDocParam                DraculaOrangeItalic
hi! link jsDocTags                 Keyword
hi! link jsDocType                 Type
hi! link jsDocTypeBrackets         DraculaCyan
hi! link jsFuncArgOperator         Operator
hi! link jsFuncArgs                DraculaOrangeItalic
hi! link jsFunction                Keyword
hi! link jsNull                    Constant
hi! link jsObjectColon             DraculaPink
hi! link jsSuper                   DraculaPurpleItalic
hi! link jsTemplateBraces          Special
hi! link jsThis                    DraculaPurpleItalic
hi! link jsUndefined               Constant

" maxmellon/vim-jsx-pretty
hi! link jsxTag             Keyword
hi! link jsxTagName         Keyword
hi! link jsxComponentName   Type
hi! link jsxCloseTag        Type
hi! link jsxAttrib          DraculaGreenItalic
hi! link jsxCloseString     Identifier
hi! link jsxOpenPunct       Identifier
" }}}

" JSON: {{{
hi! link jsonKeyword      DraculaCyan
hi! link jsonKeywordMatch DraculaPink
" }}}

" Lua: {{{
hi! link luaFunc  DraculaCyan
hi! link luaTable DraculaFg

" tbastos/vim-lua
hi! link luaBraces       DraculaFg
hi! link luaBuiltIn      Constant
hi! link luaDocTag       Keyword
hi! link luaErrHand      DraculaCyan
hi! link luaFuncArgName  DraculaOrangeItalic
hi! link luaFuncCall     Function
hi! link luaLocal        Keyword
hi! link luaSpecialTable Constant
hi! link luaSpecialValue DraculaCyan
" }}}

" Markdown: {{{
hi! link markdownBlockquote        DraculaCyan
hi! link markdownBold              DraculaOrangeBold
hi! link markdownBoldItalic        DraculaOrangeBoldItalic
hi! link markdownCodeBlock         DraculaGreen
hi! link markdownCode              DraculaGreen
hi! link markdownCodeDelimiter     DraculaGreen
hi! link markdownH1                DraculaPurpleBold
hi! link markdownH2                markdownH1
hi! link markdownH3                markdownH1
hi! link markdownH4                markdownH1
hi! link markdownH5                markdownH1
hi! link markdownH6                markdownH1
hi! link markdownHeadingDelimiter  markdownH1
hi! link markdownHeadingRule       markdownH1
hi! link markdownItalic            DraculaYellowItalic
hi! link markdownLinkText          DraculaPink
hi! link markdownListMarker        DraculaCyan
hi! link markdownOrderedListMarker DraculaCyan
hi! link markdownRule              DraculaComment
hi! link markdownUrl               DraculaLink

" plasticboy/vim-markdown
hi! link htmlBold       DraculaOrangeBold
hi! link htmlBoldItalic DraculaOrangeBoldItalic
hi! link htmlH1         DraculaPurpleBold
hi! link htmlItalic     DraculaYellowItalic
hi! link mkdBlockquote  DraculaYellowItalic
hi! link mkdBold        DraculaOrangeBold
hi! link mkdBoldItalic  DraculaOrangeBoldItalic
hi! link mkdCode        DraculaGreen
hi! link mkdCodeEnd     DraculaGreen
hi! link mkdCodeStart   DraculaGreen
hi! link mkdHeading     DraculaPurpleBold
hi! link mkdInlineUrl   DraculaLink
hi! link mkdItalic      DraculaYellowItalic
hi! link mkdLink        DraculaPink
hi! link mkdListItem    DraculaCyan
hi! link mkdRule        DraculaComment
hi! link mkdUrl         DraculaLink
" }}}

" OCaml: {{{
hi! link ocamlModule  Type
hi! link ocamlModPath Normal
hi! link ocamlLabel   DraculaOrangeItalic
" }}}

" Perl: {{{
" Regex
hi! link perlMatchStartEnd       DraculaRed

" Builtin functions
hi! link perlOperator            DraculaCyan
hi! link perlStatementFiledesc   DraculaCyan
hi! link perlStatementFiles      DraculaCyan
hi! link perlStatementFlow       DraculaCyan
hi! link perlStatementHash       DraculaCyan
hi! link perlStatementIOfunc     DraculaCyan
hi! link perlStatementIPC        DraculaCyan
hi! link perlStatementList       DraculaCyan
hi! link perlStatementMisc       DraculaCyan
hi! link perlStatementNetwork    DraculaCyan
hi! link perlStatementNumeric    DraculaCyan
hi! link perlStatementProc       DraculaCyan
hi! link perlStatementPword      DraculaCyan
hi! link perlStatementRegexp     DraculaCyan
hi! link perlStatementScalar     DraculaCyan
hi! link perlStatementSocket     DraculaCyan
hi! link perlStatementTime       DraculaCyan
hi! link perlStatementVector     DraculaCyan

" Highlighting for quoting constructs, tied to existing option in vim-perl
if get(g:, 'perl_string_as_statement', 0)
  hi! link perlStringStartEnd DraculaRed
endif

" Signatures
hi! link perlSignature           DraculaOrangeItalic
hi! link perlSubPrototype        DraculaOrangeItalic

" Hash keys
hi! link perlVarSimpleMemberName DraculaPurple
" }}}

" PHP: {{{
hi! link phpClass           Type
hi! link phpClasses         Type
hi! link phpDocTags         DraculaCyanItalic
hi! link phpFunction        Function
hi! link phpParent          Normal
hi! link phpSpecialFunction DraculaCyan
" }}}

" PlantUML: {{{
hi! link plantumlClassPrivate              SpecialKey
hi! link plantumlClassProtected            DraculaOrange
hi! link plantumlClassPublic               Function
hi! link plantumlColonLine                 String
hi! link plantumlDirectedOrVerticalArrowLR Constant
hi! link plantumlDirectedOrVerticalArrowRL Constant
hi! link plantumlHorizontalArrow           Constant
hi! link plantumlSkinParamKeyword          DraculaCyan
hi! link plantumlTypeKeyword               Keyword
" }}}

" PureScript: {{{
hi! link purescriptModule Type
hi! link purescriptImport DraculaCyan
hi! link purescriptImportAs DraculaCyan
hi! link purescriptOperator Operator
hi! link purescriptBacktick Operator
" }}}

" Python: {{{
hi! link pythonBuiltinObj    Type
hi! link pythonBuiltinObject Type
hi! link pythonBuiltinType   Type
hi! link pythonClassVar      DraculaPurpleItalic
hi! link pythonExClass       Type
hi! link pythonNone          Type
hi! link pythonRun           Comment
" }}}

" reStructuredText: {{{
hi! link rstComment                             Comment
hi! link rstTransition                          Comment
hi! link rstCodeBlock                           DraculaGreen
hi! link rstInlineLiteral                       DraculaGreen
hi! link rstLiteralBlock                        DraculaGreen
hi! link rstQuotedLiteralBlock                  DraculaGreen
hi! link rstStandaloneHyperlink                 DraculaLink
hi! link rstStrongEmphasis                      DraculaOrangeBold
hi! link rstSections                            DraculaPurpleBold
hi! link rstEmphasis                            DraculaYellowItalic
hi! link rstDirective                           Keyword
hi! link rstSubstitutionDefinition              Keyword
hi! link rstCitation                            String
hi! link rstExDirective                         String
hi! link rstFootnote                            String
hi! link rstCitationReference                   Tag
hi! link rstFootnoteReference                   Tag
hi! link rstHyperLinkReference                  Tag
hi! link rstHyperlinkTarget                     Tag
hi! link rstInlineInternalTargets               Tag
hi! link rstInterpretedTextOrHyperlinkReference Tag
hi! link rstTodo                                Todo
" }}}

" Ruby: {{{
if ! exists('g:ruby_operators')
    let g:ruby_operators=1
endif

hi! link rubyBlockArgument          DraculaOrangeItalic
hi! link rubyBlockParameter         DraculaOrangeItalic
hi! link rubyCurlyBlock             DraculaPink
hi! link rubyGlobalVariable         DraculaPurple
hi! link rubyInstanceVariable       DraculaPurpleItalic
hi! link rubyInterpolationDelimiter DraculaPink
hi! link rubyRegexpDelimiter        DraculaRed
hi! link rubyStringDelimiter        DraculaYellow
" }}}

" Rust: {{{
hi! link rustCommentLineDoc Comment
" }}}

" Sass: {{{
hi! link sassClass                  cssClassName
hi! link sassClassChar              cssClassNameDot
hi! link sassId                     cssIdentifier
hi! link sassIdChar                 cssIdentifier
hi! link sassInterpolationDelimiter DraculaPink
hi! link sassMixinName              Function
hi! link sassProperty               cssProp
hi! link sassVariableAssignment     Operator
" }}}

" Shell: {{{
hi! link shCommandSub NONE
hi! link shEscape     DraculaRed
hi! link shParen      NONE
hi! link shParenError NONE
" }}}

" Tex: {{{
hi! link texBeginEndName  DraculaOrangeItalic
hi! link texBoldItalStyle DraculaOrangeBoldItalic
hi! link texBoldStyle     DraculaOrangeBold
hi! link texInputFile     DraculaOrangeItalic
hi! link texItalStyle     DraculaYellowItalic
hi! link texLigature      DraculaPurple
hi! link texMath          DraculaPurple
hi! link texMathMatcher   DraculaPurple
hi! link texMathSymbol    DraculaPurple
hi! link texSpecialChar   DraculaPurple
hi! link texSubscripts    DraculaPurple
hi! link texTitle         DraculaFgBold
" }}}

" Typescript: {{{
hi! link typescriptAliasDeclaration       Type
hi! link typescriptArrayMethod            Function
hi! link typescriptArrowFunc              Operator
hi! link typescriptArrowFuncArg           DraculaOrangeItalic
hi! link typescriptAssign                 Operator
hi! link typescriptBOMWindowProp          Constant
hi! link typescriptBinaryOp               Operator
hi! link typescriptBraces                 Delimiter
hi! link typescriptCall                   typescriptArrowFuncArg
hi! link typescriptClassHeritage          Type
hi! link typescriptClassName              Type
hi! link typescriptDateMethod             DraculaCyan
hi! link typescriptDateStaticMethod       Function
hi! link typescriptDecorator              DraculaGreenItalic
hi! link typescriptDefaultParam           Operator
hi! link typescriptES6SetMethod           DraculaCyan
hi! link typescriptEndColons              Delimiter
hi! link typescriptEnum                   Type
hi! link typescriptEnumKeyword            Keyword
hi! link typescriptFuncComma              Delimiter
hi! link typescriptFuncKeyword            Keyword
hi! link typescriptFuncType               DraculaOrangeItalic
hi! link typescriptFuncTypeArrow          Operator
hi! link typescriptGlobal                 Type
hi! link typescriptGlobalMethod           DraculaCyan
hi! link typescriptGlobalObjects          Type
hi! link typescriptIdentifier             DraculaPurpleItalic
hi! link typescriptInterfaceHeritage      Type
hi! link typescriptInterfaceName          Type
hi! link typescriptInterpolationDelimiter Keyword
hi! link typescriptKeywordOp              Keyword
hi! link typescriptLogicSymbols           Operator
hi! link typescriptMember                 Identifier
hi! link typescriptMemberOptionality      Special
hi! link typescriptObjectColon            Special
hi! link typescriptObjectLabel            Identifier
hi! link typescriptObjectSpread           Operator
hi! link typescriptOperator               Operator
hi! link typescriptParamImpl              DraculaOrangeItalic
hi! link typescriptParens                 Delimiter
hi! link typescriptPredefinedType         Type
hi! link typescriptRestOrSpread           Operator
hi! link typescriptTernaryOp              Operator
hi! link typescriptTypeAnnotation         Special
hi! link typescriptTypeCast               Operator
hi! link typescriptTypeParameter          DraculaOrangeItalic
hi! link typescriptTypeReference          Type
hi! link typescriptUnaryOp                Operator
hi! link typescriptVariable               Keyword

hi! link tsxAttrib           DraculaGreenItalic
hi! link tsxEqual            Operator
hi! link tsxIntrinsicTagName Keyword
hi! link tsxTagName          Type
" }}}

" Vim: {{{
hi! link vimAutoCmdSfxList     Type
hi! link vimAutoEventList      Type
hi! link vimEnvVar             Constant
hi! link vimFunction           Function
hi! link vimHiBang             Keyword
hi! link vimOption             Type
hi! link vimSetMod             Keyword
hi! link vimSetSep             Delimiter
hi! link vimUserAttrbCmpltFunc Function
hi! link vimUserFunc           Function
" }}}

" XML: {{{
hi! link xmlAttrib  DraculaGreenItalic
hi! link xmlEqual   Operator
hi! link xmlTag     Delimiter
hi! link xmlTagName Statement

" Fixes missing highlight over end tags
syn region xmlTagName
	\ matchgroup=xmlTag start=+</[^ /!?<>"']\@=+
	\ matchgroup=xmlTag end=+>+
" }}}

" YAML: {{{
hi! link yamlAlias           DraculaGreenItalicUnderline
hi! link yamlAnchor          DraculaPinkItalic
hi! link yamlBlockMappingKey DraculaCyan
hi! link yamlFlowCollection  DraculaPink
hi! link yamlFlowIndicator   Delimiter
hi! link yamlNodeTag         DraculaPink
hi! link yamlPlainScalar     DraculaYellow
" }}}

" }}}

" junegunn/fzf {{{
if ! exists('g:fzf_colors')
  let g:fzf_colors = {
    \ 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Search'],
    \ 'fg+':     ['fg', 'Normal'],
    \ 'bg+':     ['bg', 'Normal'],
    \ 'hl+':     ['fg', 'DraculaOrange'],
    \ 'info':    ['fg', 'DraculaPurple'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'DraculaGreen'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'],
    \}
endif
" }}}
" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0:
