
" vim-airline 'mkarpoff' theme
" it is using current mkarpoffinal colorscheme
" and in gvim i left colors from 'wombat' theme but i am not using it anyway

" generates a dictionary which defines the colors for each highlight group
" Normal mode
"          [ guifg, guibg, ctemfg, ctermbg, opts ]
let s:N1 = [ '#141413' , '#CAE682' , 234 , 2   , 'bold'] " mode
let s:N2L= [ '#CAE682' , '#32322F' , 10  , 240 , 'bold'] " info
let s:N2R= [ '#CAE682' , '#32322F' , 232 , 240 , 'bold'] " info
let s:N3 = [ '#CAE682' , '#242424' , 2   , 235 , 'bold'] " statusline

" Insert mode
let s:I1 = [ '#141413' , '#FDE76E' , 234 , 5   , 'bold']
let s:I2L= [ '#FDE76E' , '#32322F' , 13  , 240 , 'bold']
let s:I2R= [ '#FDE76E' , '#32322F' , 232 , 240 , 'bold']
let s:I3 = [ '#FDE76E' , '#242424' , 5   , 235 , 'bold']

" Visual mode
let s:V1 = [ '#141413' , '#B5D3F3' , 234 , 4   , 'bold']
let s:V2L= [ '#B5D3F3' , '#32322F' , 12  , 240 , 'bold']
let s:V2R= [ '#B5D3F3' , '#32322F' , 232 , 240 , 'bold']
let s:V3 = [ '#B5D3F3' , '#242424' , 4   , 235 , 'bold']

" Replace mode
let s:R1 = [ '#141413' , '#E5786D' , 234 , 1   , 'bold']
let s:R2L= [ '#E5786D' , '#32322F' , 9   , 240 , 'bold']
let s:R2R= [ '#E5786D' , '#32322F' , 232 , 240 , 'bold']
let s:R3 = [ '#E5786D' , '#242424' , 1   , 235 , 'bold']

" Paste mode
let s:PA = [ '#94E42C' , 6 ]

" Info modified
let s:IM = [ '#40403C' , 7 ]

" Inactive mode
let s:IA1 = [ '#141413' , '#CAE682' , 0   , 2   ] " mode
let s:IA2 = [ '#CAE682' , '#32322F' , 232 , 240 ] " info
let s:IA3 = [ '#CAE682' , '#242424' , 242 , 233 ] " statusline

let g:airline#themes#mkarpoff#palette = {}

let g:airline#themes#mkarpoff#palette.accents = {
      \ 'red': [ '#E5786D' , '' , 203 , '' , '' ],
      \ }

let g:airline#themes#mkarpoff#palette.normal = airline#themes#generate_color_map(s:N1, s:N2L, s:N3,s:N3, s:N2R, s:N1 )
let g:airline#themes#mkarpoff#palette.insert = airline#themes#generate_color_map(s:I1, s:I2L, s:I3, s:I3, s:I2R, s:I1)
let g:airline#themes#mkarpoff#palette.visual = airline#themes#generate_color_map(s:V1, s:V2L, s:V3, s:V3, s:V2R, s:V1)
let g:airline#themes#mkarpoff#palette.replace = airline#themes#generate_color_map(s:R1, s:R2L, s:R3, s:R3, s:R2R, s:R1)
let g:airline#themes#mkarpoff#palette.insert_paste = {
    \ 'airline_a': [ s:I1[0] , s:PA[0] , s:I1[2] , s:PA[1] , ''     ] ,
    \ 'airline_b': [ s:PA[0] , s:IM[0] , s:PA[1] , s:IM[1] , ''     ] ,
    \ 'airline_c': [ s:PA[0] , s:N3[1] , s:PA[1] , s:N3[3] , ''     ] }


let g:airline#themes#mkarpoff#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)
let g:airline#themes#mkarpoff#palette.inactive_modified = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)


if !get(g:, 'loaded_ctrlp', 0)
  finish
endif

let g:airline#themes#mkarpoff#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
      \ [ '#DADADA' , '#242424' , 253 , 234 , ''     ] ,
      \ [ '#DADADA' , '#40403C' , 253 , 238 , ''     ] ,
      \ [ '#141413' , '#DADADA' , 232 , 253 , ''     ] )

