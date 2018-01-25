" C++ specific
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
inoremap <expr> <Tab>   pumvisible()? "\<C-n>"      : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible()? "\<C-p>"      : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible()? "\<C-y>\<cr>" : "\<cr>"

" syntax settings .vim/after/syntax/cpp start
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1

" syntax settings .vim/after/syntax/cpp end

call g:AleSettings()
let g:ale_linters = {'cpp': ['clang', 'clangtidy', 'cppcheck', 'cpplint', 'g++'],}

" folding options start
packadd FastFold
setlocal foldmethod=indent
setlocal shiftwidth=2
setlocal foldnestmax=1
" folding options end

function! s:Compile() 
	AsyncRun make
endfunction

function! s:CompileClean() 
	AsyncRun make clean
endfunction

let b:Compile = function('<SID>Compile')
let b:CompileClean = function('<SID>CompileClean')
