" This is a really basic asm displayer for C++ quick testing small functions.
" Easily expandable to support cmake/bazel/..., and also other programming languages.
"
" Opens asm in a new buffer. 
" Author: neoharju
" Date: 6/6/2026

" #########################################################
" Public API
" #########################################################
function! cppshowasm#show() abort
	let file = expand('%:p')
	if empty(file)
		echoerr "No file to compile"
		return
	endif

	let cmd = [
    \ 'g++',
    \ '-O3',
    \ '-g',
    \ '-S',
    \ '-march=native',
    \ '-fverbose-asm',
    \ '-masm=intel',
    \ '-o',
    \ '-',
    \ file
    \ ]

	let state = {
		\ 'output': [],
		\ 'errors': [],
		\ 'status': 0,
		\ 'srcname': expand('%:t'),
		\ }
	call job_start( cmd, {
		\	'out_mode':  'nl',
		\	'err_mode':  'nl',
		\	'in_io':     'null',
		\	'out_cb':    function('s:stdout', [state]),
		\	'err_cb':    function('s:stderr', [state]),
		\	'exit_cb':   function('s:exit', [state]),
		\	'close_cb':  function('s:close', [state]),
		\	})
	echo "Compiling assembly... "
endfunction

" #########################################################
" Job callbacks
" #########################################################
function! s:stdout(state, channel, msg) abort
	call add(a:state.output, a:msg)
endfunction

function! s:stderr(state, channel, msg) abort
	call add(a:state.errors, a:msg)
endfunction

function! s:exit(state, job, status) abort
	let a:state.status = a:status
endfunction

" close_cb fires once all buffered stdout/stderr has actually been
" delivered, which exit_cb alone does not guarantee.
function! s:close(state, channel) abort
	if a:state.status != 0
		echoerr "Compilation failed"
		if !empty(a:state.errors)
			echo join(a:state.errors, "\n")
		endif
		return
	endif
	call s:open_buffer(a:state.output, a:state.srcname)
endfunction

" #########################################################
" Buffer display
" #########################################################
function! s:open_buffer(lines, srcname) abort
	let display_lines = copy(a:lines)
	if !empty(display_lines) && empty(display_lines[-1])
		call remove(display_lines, -1)
	endif

	botright vsplit
	enew
	setlocal buftype=nofile
	setlocal bufhidden=wipe
	setlocal noswapfile
	"setlocal nobuflisted
	setlocal filetype=asm
	execute 'file '. fnameescape('[ASM] ' . a:srcname)
	call setline(1, a:lines)
endfunction
