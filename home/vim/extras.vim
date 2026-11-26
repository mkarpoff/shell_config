" Optional extras from ~/.vim/vimrc. Each needs something outside stock vim.
" Source from ~/.vimrc only on machines that have it.

" Needs: sudo, and a terminal (vim only; does not work in neovim or gvim)
cmap w!! w !sudo tee > /dev/null %

" Needs: a terminal that sends Alt as Esc-prefix (iTerm2: Option = Esc+).
" Vim only; neovim handles <M-x> keys natively and rejects the `set <M-h>=` lines.
if !has('nvim') && !has('gui_running')
  execute "set <M-h>=\eh"
  execute "set <M-j>=\ej"
  execute "set <M-k>=\ek"
  execute "set <M-l>=\el"
endif
noremap <M-h> <C-w>h
noremap <M-j> <C-w>j
noremap <M-k> <C-w>k
noremap <M-l> <C-w>l

" Needs: spell files for en (vim offers to download them over the network if missing)
if has('spell')
  command! SCon setlocal spell spelllang=en_ca
  command! SCoff setlocal nospell
endif

" Needs: a terminal that supports the xterm cursor-shape escape (not under tmux's screen TERM)
if &term ==# 'xterm-256color'
  let &t_SI = "\<Esc>[1 q"
  let &t_SR = "\<Esc>[1 q"
  let &t_EI = "\<Esc>[1 q"
endif
