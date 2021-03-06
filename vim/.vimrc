" no need filetype to load plugins
filetype off

set number " show line numbers
set relativenumber " use relative line numbers
set ruler " show line number and column is status bar
set autoread " Set to auto read when is changed outside vim
set tabstop=4 " 4 spaces per tab
set colorcolumn=120 " highlight 120 character limit
set smarttab " use smart tabs http://vim.wikia.com/wiki/Indent_with_tabs,_align_with_spaces
set smartindent
set softtabstop=4 " number of spaces when editing
set expandtab " spaces are better then tabs ;)
set cursorline " highlight current line
set wildmenu " visual autocomplete for command menu
set lazyredraw " redraw only when we need to
set showmatch " highlight matching brackets
set hlsearch " highlight search matches, use :nohlsearch to turn off
set incsearch " search as characters entered
set ignorecase " ignore case when searching
set whichwrap+=<,>,h,l,[,] " autowrap lines http://vim.wikia.com/wiki/Automatically_wrap_left_and_right
set wildmenu " turn on wild menu completions
set showmatch " show matching brackets
set splitright " splits go to the right by default
set splitbelow " splits go to bottom by default
set signcolumn=yes " extra column for linters, lsp, etc.
" Backup settings
set noswapfile
set nobackup
set scrolloff=8 " start scrolling when 8 lines from bottom of file
syntax on " syntax highlighting
set encoding=utf8
set mouse=a
set laststatus=2 " always show status bar

" plugins
" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin()
Plug 'vim-scripts/AnsiEsc.vim'
Plug 'mhinz/vim-startify'
Plug 'w0rp/ale', { 'tag': 'v3.1.0' } " ale linter
Plug 'airblade/vim-gitgutter'
Plug 'ekalinin/Dockerfile.vim', { 'for': 'Dockerfile' }
" Hashicorp stuff
Plug 'hashivim/vim-terraform', { 'for': 'terraform' }
Plug 'hashivim/vim-packer'
Plug 'hashivim/vim-vagrant'
Plug 'hashivim/vim-consul'
Plug 'hashivim/vim-vaultproject'
Plug 'google/vim-jsonnet'
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'radenling/vim-dispatch-neovim' " needed for fugitive in vim
Plug 'pearofducks/ansible-vim'
Plug 'towolf/vim-helm'
" ctags
Plug 'majutsushi/tagbar'
"Plug 'ludovicchabant/vim-gutentags'
" tpope goodness
Plug 'tpope/vim-fugitive' " git commands in vim
Plug 'tpope/vim-dispatch' " needed for ^ in neovim
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary' " easily comment stuff in/out
Plug 'tpope/vim-eunuch' " Unix file action sugar
" nerdtree stuff
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Yggdroot/indentLine' " ablity to toggle indent guides
Plug 'nathanaelkane/vim-indent-guides'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'itchyny/lightline.vim'
" ruby and rails
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'tpope/vim-endwise', { 'for': 'ruby' }
" themes
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'romainl/flattened' " solarized variant
Plug 'iCyMind/NeoSolarized'
Plug 'lifepillar/vim-solarized8'
Plug 'joshdick/onedark.vim'
Plug 'KeitaNakamura/neodark.vim'
Plug 'mhartington/oceanic-next'
Plug 'arcticicestudio/nord-vim'
" Search Stuff
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'edkolev/tmuxline.vim'
" undotree to make undo history easier
 Plug 'mbbill/undotree', {'tag': 'rel_6.1'}
" file icons
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'
call plug#end()
"disable polygot for golang
if exists('g:loaded_polyglot')
    let g:polyglot_disabled = ['go']
endif

" set leader
let mapleader = " "


" load file type specific indent files
filetype plugin on
set foldmethod=syntax " fold code based on syntax by default
set foldlevel=99 " code unfoled by default
let g:vim_json_syntax_conceal = 0 " stop hiding quotes in json
" set Vim-specific sequences for RGB colors
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum
" set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
if (has("termguicolors"))
 set termguicolors
endif
try
  colorscheme onedark
catch
endtry
set background=dark

" vim hardcodes background color erase even if the terminfo file does
" not contain bce (not to mention that libvte based terminals
" incorrectly contain bce in their terminfo files). This causes
" incorrect background rendering when using a color theme with a
" background color.
  let &t_ut=''



 set guifont=Hack\ Nerd\ Font\ Mono\ Regular:h12

""""""""""""""""""""""""""""
" plugin specific settings "
""""""""""""""""""""""""""""
" show hidden files in fzf
let $FZF_DEFAULT_COMMAND = 'rg --hidden --glob ''!.git'' -l ""'
" ctrp settings
let g:ctrlp_show_hidden=1
let g:terraform_fmt_on_save=1
" indent line plugin
"let g:indentLine_setColors = 0
let g:indentLine_setConceal = 0
" markdown
let g:vim_markdown_conceal = 0
let g:vim_markdown_frontmatter = 1  " for YAML format
let g:vim_markdown_toml_frontmatter = 1  " for TOML format
let g:vim_markdown_json_frontmatter = 1  " for JSON format
" end markdown "
" lightline status bar
" let g:lightline = {
"       \ 'colorscheme': 'solarized',
"         \ 'active': {
"       \   'left': [ [ 'mode', 'paste' ],
"       \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
"       \ },
"       \ 'component_function': {
"       \   'gitbranch': 'FugitiveHead'
"       \ },
"       \ }
" airline status bar
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#gutentags#enabled = 1
let g:airline_theme='neodark'
" end airline "
"NerdTREE settings
let NERDTreeShowHidden=1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"""""""""""""""""""""""""""
"       ale settings       "
""""""""""""""""""""""""""""
let g:ale_ignore_lsp = 1 " don't use ale's lsp since I have coc running
let g:ale_fix_on_save = 1
" end ale "

"""""""""""
" coc.vim "
"""""""""""
set cmdheight=2
set hidden
set shortmess+=c
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

if has('nvim')
  " We have to do this to fix a bug with Neovim on OS X where C-h
  " is sent as backspace for some reason.
  nnoremap <BS> <C-W>h
endif

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')
" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" end coc"

""""""""""""""""""""""""""""
"        mappings          "
""""""""""""""""""""""""""""
map <leader>ntt :NERDTreeToggle<CR>
map <leader>nts :NERDTreeFind<CR>
""""""""""""""""""""""""""""
"        commands          "
""""""""""""""""""""""""""""
com! FormatJSON %!jq .
:command! OpenInVSCode exe "silent !code --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!

""""""""""""""""""""""""""""
"     autocmd stuff        "
""""""""""""""""""""""""""""


fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    keepp %s/\s\+$//e
    call cursor(l, c)
endfun

" keep auto commands grouped to avoid sourcing multiple times
augroup MY_STUFF
  autocmd FileType jenkinsfile setlocal commentstring=#\ %s
  " vim-dockerfile not correctly setting filetype
  autocmd FileType dockerfile set ft=Dockerfile
  autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
augroup END


" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
