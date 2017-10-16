" Python Specific
call g:AleSettings()
call ColorColumn(121)
setlocal number
setlocal nowrap
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal expandtab
setlocal tabstop=4

packadd FastFold
setlocal foldmethod=indent

packadd vim-indentguides
let g:indentguides_spacechar = '|'
let g:indentguides_tabchar = '>'

setlocal nolist

packadd completor.vim
inoremap <expr> <Tab>   pumvisible()? "\<C-n>"      : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible()? "\<C-p>"      : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible()? "\<C-y>\<cr>" : "\<cr>"

