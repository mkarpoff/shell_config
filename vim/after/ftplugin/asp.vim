
function! s:Compile() 
	AsyncRun clingo %
endfunction

function! s:CompileClean() 
	AsyncRun echo "Nothing to clean"
endfunction

let b:Compile = function('<SID>Compile')
let b:CompileClean = function('<SID>CompileClean')
