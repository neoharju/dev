if exists('g:loaded_cppshowasm')
	finish
endif

let g:loaded_cppshowasm = 1

command! CppShowAsm call cppshowasm#show()
