"""
" Environment Specific settings
" ALE specific package .vim/pack/git-plugins/opt/ale
"""
highlight ALEErrorSign ctermfg=160 ctermbg=232 guifg=#ff0000 guibg=#080808
highlight ALEWarningSign ctermfg=202 ctermbg=234 guifg=#ff5f00 guibg=#1c1c1c
highlight ALEInfoSign ctermfg=45 ctermbg=234
highlight ALESignColumnWithErrors ctermfg=243 ctermbg=5 guifg=#767676 guibg=#080808
highlight ALESignColumnWithoutErrors ctermfg=239 ctermbg=234 guifg=#4e4e4e guibg=#1c1c1c
let g:airline#extensions#ale#enabled = 1
let g:ale_set_loclist=0
let g:ale_sign_column_always=1
let g:ale_sign_error='E>'
let g:ale_sign_warning='W>'
let g:ale_change_sign_column_color=1
let g:ale_echo_msg_format='[%linter%] [%severity%] %s'
