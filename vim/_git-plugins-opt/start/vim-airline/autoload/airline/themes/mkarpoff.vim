
" vim-airline 'mkarpoff' theme
" it is using current mkarpoffinal colorscheme
" and in gvim i left colors from 'wombat' theme but i am not using it anyway

" generates a dictionary which defines the colors for each highlight group
" Normal mode
"          [ guifg, guibg, ctemfg, ctermbg, opts ]
" Colors:
let s:BLK = 232
let s:RED = 160
let s:GRN = 70
let s:YEL = 178
let s:BLU = 32
let s:PRP = 96
let s:AQU = 37
let s:GRY = 240
let s:GRYD= 235

let s:N1 = [ '#141413' , '#CAE682' , s:BLK, s:GRN , 'bold'] " mode
let s:N2L= [ '#CAE682' , '#32322F' , s:GRN, s:GRY , 'bold'] " info
let s:N2R= [ '#CAE682' , '#32322F' , s:BLK, s:GRY , 'bold'] " info
let s:N3 = [ '#CAE682' , '#242424' , s:GRN, s:GRYD, 'bold'] " statusline

" Insert mode
let s:I1 = [ '#141413' , '#FDE76E' , s:BLK, s:PRP , 'bold']
let s:I2L= [ '#FDE76E' , '#32322F' , s:PRP, s:GRY , 'bold']
let s:I2R= [ '#FDE76E' , '#32322F' , s:BLK, s:GRY , 'bold']
let s:I3 = [ '#FDE76E' , '#242424' , s:PRP, s:GRYD, 'bold']

" Visual mode
let s:V1 = [ '#141413' , '#B5D3F3' , s:BLK, s:BLU , 'bold']
let s:V2L= [ '#B5D3F3' , '#32322F' , s:BLU, s:GRY , 'bold']
let s:V2R= [ '#B5D3F3' , '#32322F' , s:BLK, s:GRY , 'bold']
let s:V3 = [ '#B5D3F3' , '#242424' , s:BLU, s:GRYD, 'bold']

" Replace mode
let s:R1 = [ '#141413' , '#E5786D' , s:BLK, s:RED , 'bold']
let s:R2L= [ '#E5786D' , '#32322F' , s:RED, s:GRY , 'bold']
let s:R2R= [ '#E5786D' , '#32322F' , s:BLK, s:GRY , 'bold']
let s:R3 = [ '#E5786D' , '#242424' , s:RED, s:GRYD, 'bold']

" Paste mode
let s:PA = [ '#94E42C' , s:AQU ]

" Info modified
let s:IM = [ '#40403C' , s:GRYD ]

" Inactive mode
let s:IA1 = [ '#141413' , '#CAE682' , s:BLK, s:GRN ] " mode
let s:IA2 = [ '#CAE682' , '#32322F' , s:BLK, s:GRY ] " info
let s:IA3 = [ '#CAE682' , '#242424' , s:GRN, s:GRYD ] " statusline

" Tabline active inactive
let s:TA = [ '#141413' , '#CAE682' , s:BLK, s:GRN  ] " active
let s:TI = [ '#CAE682' , '#32322F' , s:BLK, s:GRYD ] " inactive


let g:airline#themes#mkarpoff#palette = {}

let g:airline#themes#mkarpoff#palette.normal = airline#themes#generate_color_map(s:N1, s:N2L, s:N3,s:N3, s:N2R, s:N1 )
let g:airline#themes#mkarpoff#palette.insert = airline#themes#generate_color_map(s:I1, s:I2L, s:I3, s:I3, s:I2R, s:I1)
let g:airline#themes#mkarpoff#palette.visual = airline#themes#generate_color_map(s:V1, s:V2L, s:V3, s:V3, s:V2R, s:V1)
let g:airline#themes#mkarpoff#palette.replace = airline#themes#generate_color_map(s:R1, s:R2L, s:R3, s:R3, s:R2R, s:R1)
let g:airline#themes#mkarpoff#palette.tabline = {
    \ 'airline_tabmod'      : s:TA ,
    \ 'airline_tabmod_unsel': s:TI }
let g:airline#themes#mkarpoff#palette.insert_paste = {
    \ 'airline_a': [ s:I1[0] , s:PA[0] , s:I1[2] , s:PA[1] , ''     ] ,
    \ 'airline_b': [ s:PA[0] , s:IM[0] , s:PA[1] , s:IM[1] , ''     ] ,
    \ 'airline_c': [ s:PA[0] , s:N3[1] , s:PA[1] , s:N3[3] , ''     ] }


let g:airline#themes#mkarpoff#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)
let g:airline#themes#mkarpoff#palette.inactive_modified = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)


