"""
" vim-airline plugin settings
"""
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline#extensions#whitespace#mixed_indent_algo=1
let g:airline_theme='mkarpoff'

" unicode symbols
let g:airline_symbols.linenr = '≡'
let g:airline_symbols.crypt = ''
let g:airline_symbols.whitespace= 'Ξ'
let g:airline_symbols.notexists= '∄'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.spell = '§'
