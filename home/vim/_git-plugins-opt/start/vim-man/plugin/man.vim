"""
" vim-man package settings
"""
cnoremap <nowait> <expr> man getcmdtype() ==# ':' && getcmdpos() == 1 ? 'Man' : 'man'

