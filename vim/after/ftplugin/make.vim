" Make specific
setlocal autoindent
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4

function! s:Compile() 
	AsyncRun make
endfunction

function! s:CompileClean() 
	AsyncRun make clean
endfunction

let b:Compile = function('<SID>Compile')
let b:CompileClean = function('<SID>CompileClean')
