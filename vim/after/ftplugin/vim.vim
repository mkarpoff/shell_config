" Vim Specific
call g:AleSettings()

function! s:Compile() 
	source ~/.vim/vimrc
	echo Reloaded
endfunction

let b:Compile = function('<SID>Compile')
