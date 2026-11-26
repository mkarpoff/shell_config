scriptencoding utf-8
" statusline.vim: plugin-free status line and tabline (mkarpoff).
" Replaces the old vim-airline look (theme 'mkarpoff'). Source it after
" minimal-vimrc.vim:   source /path/to/statusline.vim
"
" Symbols toggle: g:statusline_fancy (1 = fancy, 0 = plain ASCII).
" Terminal vim cannot see which font the terminal uses, so set it to 0 if
" the symbols show as boxes. Unset means 1 when &encoding is utf-8, else 0.
" It is read every time the status line is built, so change it live with:
"   :let g:statusline_fancy = 0 | redraw!
" Fancy set: the airline symbols (≡ line, Þ paste, § spell, ∄ not on disk).
" Plain set: ASCII (ln, PASTE, SPELL, [new]).
"
" Git branch: read with one `git` call per buffer, cached in
" b:statusline_branch and refreshed on BufEnter, BufWritePost and
" FocusGained only. Empty when the file is not in a repo or git is missing.
"
" Works on vim 7.4+ and neovim. Safe to source more than once.

if exists('&laststatus')
  set laststatus=2
endif
set showtabline=2            " airline's tabline was always shown
set noshowmode               " the mode block shows the mode

" ---------------------------------------------------------------- colors
" From airline/themes/mkarpoff.vim: [guifg, guibg, ctermfg, ctermbg, bold]
function! s:Colors() abort
  let l:tco = exists('&t_Co') ? str2nr(&t_Co) : 256
  " t_Co 0 means not known yet (VimEnter re-runs this): use the 256 set.
  if has('nvim') || has('gui_running') || l:tco >= 256 || l:tco < 8
    let c = {'BLK': 232, 'RED': 160, 'GRN': 70, 'BLU': 32, 'PRP': 96,
          \  'AQU': 37, 'GRY': 240, 'GRYD': 235}
  else
    " shortcut: 8/16-color terminals get the nearest basic colors.
    let c = {'BLK': 0, 'RED': 1, 'GRN': 2, 'BLU': 4, 'PRP': 5,
          \  'AQU': 6, 'GRY': 7, 'GRYD': 0}
  endif
  let modes = {
        \ 'Normal':  ['#CAE682', c.GRN],
        \ 'Insert':  ['#FDE76E', c.PRP],
        \ 'Visual':  ['#B5D3F3', c.BLU],
        \ 'Replace': ['#E5786D', c.RED]}
  let g = {}
  for [name, col] in items(modes)
    let g['Stl' . name . 'A'] = ['#141413', col[0], c.BLK, col[1], 1]  " mode
    let g['Stl' . name . 'B'] = [col[0], '#32322F', col[1], c.GRY, 1]  " info left
    let g['Stl' . name . 'C'] = [col[0], '#242424', col[1], c.GRYD, 1] " middle
    let g['Stl' . name . 'Y'] = [col[0], '#32322F', c.BLK, c.GRY, 1]   " info right
  endfor
  let g.StlInactiveA = ['#141413', '#CAE682', c.BLK, c.GRN, 0]
  let g.StlInactiveB = ['#CAE682', '#32322F', c.BLK, c.GRY, 0]
  let g.StlInactiveC = ['#CAE682', '#242424', c.GRN, c.GRYD, 0]
  let g.StlPaste     = ['#141413', '#94E42C', c.BLK, c.AQU, 1]
  let g.StlTabSel    = ['#141413', '#CAE682', c.BLK, c.GRN, 1]
  let g.StlTab       = ['#CAE682', '#32322F', c.GRN, c.GRYD, 0]
  let g.StlTabFill   = ['#CAE682', '#242424', c.GRN, c.GRYD, 0]
  return g
endfunction

function! s:Highlight() abort
  for [grp, v] in items(s:Colors())
    let attr = v[4] ? 'bold' : 'NONE'
    execute 'highlight' grp 'guifg=' . v[0] 'guibg=' . v[1]
          \ 'ctermfg=' . v[2] 'ctermbg=' . v[3]
          \ 'gui=' . attr 'cterm=' . attr 'term=' . attr
  endfor
endfunction

" ---------------------------------------------------------------- symbols
function! s:Fancy() abort
  if exists('g:statusline_fancy')
    return g:statusline_fancy ? 1 : 0
  endif
  return &encoding ==# 'utf-8'
endfunction

function! s:Symbols() abort
  if s:Fancy()
    return {'linenr': '≡', 'paste': 'Þ', 'spell': '§', 'notexists': '∄'}
  endif
  return {'linenr': 'ln', 'paste': 'PASTE', 'spell': 'SPELL', 'notexists': '[new]'}
endfunction

" ---------------------------------------------------------------- git
function! s:GitBranch() abort
  let b:statusline_branch = ''
  if &buftype !=# '' || !executable('git')
    return
  endif
  let dir = expand('%:p:h')
  if dir ==# '' || !isdirectory(dir)
    let dir = getcwd()
  endif
  let out = system('git -C ' . shellescape(dir) . ' rev-parse --abbrev-ref HEAD')
  if v:shell_error
    return
  endif
  let out = substitute(out, '\n.*', '', '')
  if out ==# 'HEAD'
    let out = substitute(system('git -C ' . shellescape(dir) . ' rev-parse --short HEAD'), '\n.*', '', '')
    if v:shell_error
      return
    endif
  endif
  let b:statusline_branch = out
endfunction

" ---------------------------------------------------------------- statusline
let s:mode_names = {
      \ 'n': ['NORMAL', 'Normal'], 'i': ['INSERT', 'Insert'],
      \ 'R': ['REPLACE', 'Replace'], 'v': ['VISUAL', 'Visual'],
      \ 'V': ['V-LINE', 'Visual'], "\<C-v>": ['V-BLOCK', 'Visual'],
      \ 's': ['SELECT', 'Visual'], 'S': ['S-LINE', 'Visual'],
      \ "\<C-s>": ['S-BLOCK', 'Visual'], 'c': ['COMMAND', 'Normal'],
      \ 't': ['TERMINAL', 'Insert']}

function! s:Esc(s) abort
  return substitute(a:s, '%', '%%', 'g')
endfunction

function! StatuslineBuild(active) abort
  let sym = s:Symbols()
  let branch = s:Esc(get(b:, 'statusline_branch', ''))
  let fname = expand('%:p')
  let missing = fname !=# '' && &buftype ==# '' && !filereadable(fname)
  let enc = (&fileencoding !=# '' ? &fileencoding : &encoding)
        \ . (&fileformat !=# 'unix' ? '[' . &fileformat . ']' : '')

  if !a:active
    return '%#StlInactiveA# %f%m%r %#StlInactiveC#%=%#StlInactiveB# %3p%% '
          \ . sym.linenr . ' %l/%L :%v '
  endif

  let m = get(s:mode_names, mode()[0], ['NORMAL', 'Normal'])
  let g = 'Stl' . m[1]
  let s = '%#' . g . 'A# ' . m[0] . ' '
  if &paste
    let s .= '%#StlPaste# ' . sym.paste . ' '
  endif
  if &spell
    let s .= '%#' . g . 'A#| ' . sym.spell . ' ' . s:Esc(&spelllang) . ' '
  endif
  let s .= '%#' . g . 'B#' . (branch !=# '' ? ' ' . branch . ' ' : '')
  let s .= '%#' . g . 'C# %f%m%r' . (missing ? ' ' . sym.notexists : '') . ' '
  let s .= '%='
  let s .= (&filetype !=# '' ? s:Esc(&filetype) . ' | ' : '')
  let s .= '%#' . g . 'Y# ' . s:Esc(enc) . ' '
  let s .= '%#' . g . 'A# %3p%% ' . sym.linenr . ' %l/%L :%v '
  return s
endfunction

" ---------------------------------------------------------------- tabline
" Numbered tabs, like airline's tab_nr_type=1.
function! StatuslineTabline() abort
  let s = ''
  for t in range(1, tabpagenr('$'))
    let bufs = tabpagebuflist(t)
    let name = bufname(bufs[tabpagewinnr(t) - 1])
    let name = name ==# '' ? '[No Name]' : fnamemodify(name, ':t')
    let modified = 0
    for b in bufs
      if getbufvar(b, '&modified')
        let modified = 1
      endif
    endfor
    let s .= (t == tabpagenr() ? '%#StlTabSel#' : '%#StlTab#')
    let s .= '%' . t . 'T ' . t . ' ' . s:Esc(name) . (modified ? ' +' : '') . ' '
  endfor
  return s . '%#StlTabFill#%T'
endfunction

" ---------------------------------------------------------------- wiring
function! s:SetActive(active) abort
  let &l:statusline = '%!StatuslineBuild(' . a:active . ')'
endfunction

augroup StatuslinePlain
  autocmd!
  autocmd ColorScheme,VimEnter * call s:Highlight()
  autocmd BufEnter,BufWritePost * call s:GitBranch()
  autocmd FocusGained * call s:GitBranch()
  autocmd VimEnter,WinEnter,BufWinEnter * call s:SetActive(1)
  autocmd WinLeave * call s:SetActive(0)
augroup END

call s:Highlight()
set tabline=%!StatuslineTabline()
set statusline=%!StatuslineBuild(1)
" Set the window that is current at source time and refresh its branch.
call s:GitBranch()
call s:SetActive(1)
