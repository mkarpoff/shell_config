" LaTeX specific
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

vmap j gj
vmap k gk
vmap A g$a
vmap 0 g0
vmap $ g$

" Use the old regex engine explicitly the newer robust one doesn't do well
" with long lines
setlocal regexpengine=1

packadd ale

packadd completor.vim
let g:completor_tex_omni_trigger =
        \   '\\(?:'
        \  .   '\w*cite\w*(?:\s*\[[^]]*\]){0,2}\s*{[^}]*'
        \  .  '|\w*ref(?:\s*\{[^}]*|range\s*\{[^,}]*(?:}{)?)'
        \  .  '|hyperref\s*\[[^]]*'
        \  .  '|includegraphics\*?(?:\s*\[[^]]*\]){0,2}\s*\{[^}]*'
        \  .  '|(?:include(?:only)?|input)\s*\{[^}]*'
        \  .')'

" folding options start
packadd FastFold
let g:tex_fold_enabled=1
setlocal shiftwidth=2
autocmd InsertLeave,WinEnter * setlocal foldmethod=syntax
autocmd InsertEnter,WinLeave * setlocal foldmethod=manual
" folding options end

function! s:Compile() 
	AsyncRun rubber --pdf --inplace %
endfunction

function! s:CompileClean() 
	AsyncRun rubber --pdf --clean --inplace %
endfunction
"autocmd QuickFixCmdPost * call asyncrun#quickfix_toggle(2, 1)

let b:Compile = function('<SID>Compile')
let b:CompileClean = function('<SID>CompileClean')
