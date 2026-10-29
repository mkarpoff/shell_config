function! s:Compile() 
	AsyncRun clingo %
endfunction

function! s:CompileClean() 
	AsyncRun echo "Nothing to clean"
endfunction

let b:Compile = function('<SID>Compile')
let b:CompileClean = function('<SID>CompileClean')
autocmd QuickFixCmdPost * call asyncrun#quickfix_toggle(15, 1)

set nowrap
set tabstop=4
set softtabstop=4
