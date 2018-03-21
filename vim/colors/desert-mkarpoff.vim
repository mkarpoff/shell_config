" Vim color file
" Maintainer:	Marcus Karpoff mkarpoff@ualberta.ca
" Last Change:	
" Last Change:
" URL:		
" Version:	$Id: mkarpoff.vim,v 0.1 $

" cool help screens
" :he group-name
" :he highlight-groups
" :he cterm-colors

set background=dark
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
	syntax reset
    endif
endif
let g:colors_name="mkarpoff"

hi Normal	guifg=LightGrey guibg=Black
hi Normal	ctermfg=LightGrey ctermbg=Black

" highlight groups
hi Cursor	guibg=khaki guifg=slategrey
"hi CursorIM
"hi Directory
"hi DiffAdd
"hi DiffChange
"hi DiffDelete
"hi DiffText
"hi ErrorMsg
"hi VertSplit	guibg=#c2bfa5 guifg=grey50 gui=none
hi Folded	guibg=grey30 guifg=gold
hi FoldColumn	guibg=grey30 guifg=tan
hi IncSearch	guifg=slategrey guibg=khaki
"hi LineNr
hi ModeMsg	guifg=goldenrod
hi MoreMsg	guifg=SeaGreen
hi NonText	guifg=LightBlue guibg=grey30
hi Question	guifg=springgreen
hi Search	guibg=peru guifg=wheat
hi SpecialKey	guifg=yellowgreen
hi StatusLine	guibg=#c2bfa5 guifg=black gui=none
hi StatusLineNC	guibg=#c2bfa5 guifg=grey50 gui=none
hi Title	guifg=indianred
hi Visual	gui=none guifg=khaki guibg=olivedrab
"hi VisualNOS
hi WarningMsg	guifg=salmon
"hi WildMenu
"hi Menu
"hi Scrollbar
"hi Tooltip

" syntax highlighting groups
hi Comment	guifg=SkyBlue
hi Constant	guifg=#ffa0a0
hi Identifier	guifg=palegreen
hi Statement	guifg=khaki
hi PreProc	guifg=indianred
hi Type		guifg=darkkhaki
hi Special	guifg=navajowhite
"hi Underlined
hi Ignore	guifg=grey40
"hi Error
hi Todo		guifg=orangered guibg=yellow2

" color terminal definitions
hi SpecialKey	ctermfg=darkgreen
hi NonText	cterm=bold ctermfg=darkblue
hi Directory	ctermfg=darkcyan
hi ErrorMsg	cterm=bold ctermfg=7 ctermbg=1
hi IncSearch	cterm=NONE ctermfg=yellow ctermbg=green
hi Search	cterm=NONE ctermfg=grey ctermbg=blue
hi MoreMsg	ctermfg=darkgreen
hi ModeMsg	cterm=NONE ctermfg=brown
"hi LineNr	ctermfg=3
hi Question	ctermfg=green
"hi StatusLine	cterm=bold,reverse
"hi StatusLineNC cterm=reverse
"hi VertSplit	cterm=reverse
hi Title	ctermfg=5
hi Visual	cterm=reverse
hi VisualNOS	cterm=bold,underline
hi WarningMsg	ctermfg=1
hi WildMenu	ctermfg=0 ctermbg=3
hi Folded	ctermfg=darkgrey ctermbg=NONE
hi FoldColumn	ctermfg=darkgrey ctermbg=NONE
hi DiffAdd	ctermbg=4
hi DiffChange	ctermbg=5
hi DiffDelete	cterm=bold ctermfg=4 ctermbg=6
hi DiffText	cterm=bold ctermbg=1
hi Comment	ctermfg=darkcyan
hi Constant	ctermfg=brown
hi Special	ctermfg=5
hi Identifier	ctermfg=6
hi Statement	ctermfg=3
hi PreProc	ctermfg=5
hi Type		ctermfg=2
hi Underlined	cterm=underline ctermfg=5
hi Ignore	cterm=bold ctermfg=7
hi Ignore	ctermfg=darkgrey
hi Error	cterm=bold ctermfg=7 ctermbg=1


"
" Color Scheme
highlight LineNr term=bold ctermfg=242 ctermbg=237 gui=bold guifg=#4e4e4e guibg=#1c1c1c
highlight StatusLineNC term=bold cterm=bold ctermfg=239 ctermbg=234
highlight StatusLineNC gui=bold guifg=#4e4e4e guibg=#1c1c1c
highlight VertSplit term=bold cterm=bold ctermfg=239 ctermbg=234
highlight VertSplit gui=bold guifg=#4e4e4e guibg=#1c1c1c
highlight ColorColumn term=bold cterm=bold ctermfg=239 ctermbg=234
highlight ColorColumn gui=bold guifg=#4e4e4e guibg=#1c1c1c
"highlight StatusLineNC gui=bold guifg=#4e4e4e guibg=#1c1c1c
"highlight StatusLineNC ctermfg=239 ctermbg=234
"highlight VertSplit ctermfg=239 ctermbg=234
"highlight VertSplit gui=bold guifg=#4e4e4e guibg=#1c1c1c
"highlight ColorColumn ctermfg=239 ctermbg=234
"highlight ColorColumn gui=bold guifg=#4e4e4e guibg=#1c1c1c
highlight Search term=reverse ctermfg=234 ctermbg=12 guifg=wheat guibg=peru
highlight SpellLocal term=underline cterm=bold,underline ctermfg=14 ctermbg=0 gui=undercurl guisp=Cyan
highlight SpellBad term=reverse cterm=bold,underline ctermfg=9 ctermbg=0 gui=undercurl guisp=Red
highlight ErrorMsg term=standout cterm=bold,underline ctermfg=1 ctermbg=0 guifg=White guibg=Red 
highlight Error term=standout cterm=bold,underline ctermfg=1 ctermbg=0 guifg=White guibg=Red 

"highlight NonText ctermbg=234 guibg=#1c1c1c
"highlight clear SignColumn
