" LaTeX specific
call g:AleSettings()
setlocal textwidth=999999
setlocal wrap
setlocal linebreak
setlocal showbreak=+--
setlocal number
SCon
ColorColumn(0)
nmap j gj
nmap k gk
nmap I g0i
nmap A g$a
nmap 0 g0
nmap $ g$

packadd completor.vim
let g:completor_tex_omni_trigger =
        \   '\\(?:'
        \  .   '\w*cite\w*(?:\s*\[[^]]*\]){0,2}\s*{[^}]*'
        \  .  '|\w*ref(?:\s*\{[^}]*|range\s*\{[^,}]*(?:}{)?)'
        \  .  '|hyperref\s*\[[^]]*'
        \  .  '|includegraphics\*?(?:\s*\[[^]]*\]){0,2}\s*\{[^}]*'
        \  .  '|(?:include(?:only)?|input)\s*\{[^}]*'
        \  .')'
inoremap <expr> <Tab>   pumvisible()? "\<C-n>"      : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible()? "\<C-p>"      : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible()? "\<C-y>\<cr>" : "\<cr>"

" folding options start
packadd FastFold
setlocal foldmethod=indent
setlocal shiftwidth=2
setlocal foldnestmax=1
" folding options end
"
function! s:Compile() 
	AsyncRun rubber --pdf --inplace %
endfunction

function! s:CompileClean() 
	AsyncRun rubber --pdf --clean --inplace %
endfunction
autocmd QuickFixCmdPost * call asyncrun#quickfix_toggle(2, 1)

let b:Compile = function('<SID>Compile')
let b:CompileClean = function('<SID>CompileClean')
