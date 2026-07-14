" Script is taken from:
" https://vimhelp.org/wayland.txt.html#wayland
" 
" This requires users to have wl-clipboard installed
" e.g. sudo apt install wl-clipboard

vim9script
# When using wl-clipboard I am getting
# weird symbols that are not part of the code
# after using copy/paste. To get rid of them
# I simply have to :redraw!  
def Available(): bool
	return executable('wl-copy') && executable('wl-paste')
enddef

def Copy(reg: string, type: string, str: list<string>)
	system("wl-copy", str)
	# redraw to get rid of symbol 
	#redraw! 
enddef

def Paste(reg: string): tuple<string, list<string>>
	var args = "wl-paste --type text/plain;charset=utf-8"

	# we need to get systemlist to a var to be able to redraw once more
	var systeml = systemlist(args)
	#redraw!
	return ("", systeml)
enddef

v:clipproviders["wl_clipboard"] = {
	available: Available,
	copy: {
		"+": Copy,
	},
	paste: {
		"+": Paste,
	}
}
# DONT FORGET TO SET
set clipmethod=wl_clipboard
