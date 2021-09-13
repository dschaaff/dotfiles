"NerdTREE settings
let NERDTreeShowHidden=1

" Nerdtree specific mappings
map <leader>ntt :NERDTreeToggle<CR>
map <leader>nts :NERDTreeFind<CR>
map <leader>ntf :NERDTreeFocus<CR>

" keep auto commands grouped to avoid sourcing multiple times
augroup my_nerdtree
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END
