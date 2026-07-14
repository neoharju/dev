nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@

vnoremap <leader>g :<c-u> call <SID>GrepOperator(visualmode())<cr>
" :help <SID>
" s: for scripts namespace (otherwise global)
function! s:GrepOperator(type)
	" save previous yank
	let saved_unnamed_register = @@
	if a:type ==# 'v'
		normal! `<v`>y"
	elseif a:type ==# 'char'
		normal! `[v`]y"
	else
		return
	endif

    " Echo the yanked text from unnamed register @
	silent execute "grep! " . shellescape(@@) . " ."
	
	" Need to redraw vim, otherwise everything black due to use of silent
	" https://github.com/vim/vim/issues/1253
	redraw! 
	copen

    " restore previous yank to unnamed register
	let @@ = saved_unnamed_register
	
endfunction
