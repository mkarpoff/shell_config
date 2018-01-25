" LaTeX specific
call g:AleSettings()
setlocal textwidth=999999
setlocal wrap
setlocal linebreak
setlocal showbreak=+--
setlocal number
SCon
map j gj
map k gk

function! s:Compile() 
	AsyncRun rubber --pdf %
endfunction

function! s:CompileClean() 
	AsyncRun rubber --pdf --clean %
endfunction

let b:Compile = function('<SID>Compile')
let b:CompileClean = function('<SID>CompileClean')
