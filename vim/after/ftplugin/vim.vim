" Vim Specific
call g:AleSettings()

function! s:Compile() 
	source ~/.vim/vimrc
endfunction

let b:Compile = function('<SID>Compile')
