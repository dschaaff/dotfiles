" airline status bar
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#gutentags#enabled = 1
" straight tabs
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'
" straight separators
let g:airline_left_sep=' '
let g:airline_right_sep=' '
let g:airline_theme='onedark'
