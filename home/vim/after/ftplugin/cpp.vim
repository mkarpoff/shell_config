"""
" C++ specific
"""
packadd vim-cpp-enhanced-highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
syntax enable
call ColorColumn(121)
setlocal expandtab
setlocal tabstop=2
setlocal number
setlocal nowrap

packadd completor.vim
let g:completor_clang_binary='/usr/bin/clang'

" syntax settings .vim/after/syntax/cpp start
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
" syntax settings .vim/after/syntax/cpp end

packadd ale
let g:ale_linters = {'cpp': ['clang', 'clangtidy', 'cppcheck', 'cpplint', 'g++'],}

" folding options start
packadd FastFold
setlocal foldmethod=indent
setlocal shiftwidth=2
setlocal foldnestmax=1
" folding options end

packadd vim-autoformat

