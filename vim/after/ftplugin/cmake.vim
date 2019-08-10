
packadd vim-autoformat

function! s:Compile() 
	AsyncRun cmake <cwd>
endfunction

function! s:CompileClean() 
endfunction

let b:Compile = function('<SID>Compile')
let b:CompileClean = function('<SID>CompileClean')
