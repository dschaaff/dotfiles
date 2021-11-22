" no need filetype to load plugins
filetype off

set number " show line numbers
set relativenumber " use relative line numbers
set ruler " show line number and column is status bar
set autoread " Set to auto read when is changed outside vim
set tabstop=4 softtabstop=4 " 4 spaces per tab
set shiftwidth=4
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
set signcolumn=auto " extra column for linters, lsp, etc.
set termguicolors
set guifont=HackNerdFontCompleteM
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
" don't use lsp in ale
let g:ale_disable_lsp = 1
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin()
Plug 'nvim-treesitter/nvim-treesitter', {'branch': '0.5-compat', 'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'akinsho/nvim-toggleterm.lua'

" Plug 'neovim/nvim-lspconfig'

" compe provides autocompletion
" Plug 'hrsh7th/nvim-compe'
" vnsip for lsp snippet completions
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'vim-scripts/AnsiEsc.vim'
" Plug 'airblade/vim-gitgutter'
Plug 'mhinz/vim-signify'

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
Plug 'radenling/vim-dispatch-neovim' " needed for fugitive in neovim
Plug 'pearofducks/ansible-vim'
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
Plug 'tpope/vim-rsi' " readline shortcut keys in insert mode
" better git commit window
Plug 'rhysd/committia.vim'

Plug 'rhysd/conflict-marker.vim' " git conflict marker

" linting support
Plug 'dense-analysis/ale', { 'tag': 'v3.1.0' }

" nvim tree
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

" ofumo/vim-nerdtree-syntax-highlight'
" Plug 'Yggdroot/indentLine' " ablity to toggle indent guides
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" ruby and rails
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'tpope/vim-endwise', { 'for': 'ruby' }

" themes
Plug 'romainl/flattened' " solarized variant
Plug 'iCyMind/NeoSolarized'
Plug 'lifepillar/vim-solarized8'
Plug 'joshdick/onedark.vim'
Plug 'KeitaNakamura/neodark.vim'
Plug 'mhartington/oceanic-next'
Plug 'arcticicestudio/nord-vim'

Plug 'edkolev/tmuxline.vim'

" trying out telescope
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'towolf/vim-helm'
" undotree to make undo history easier
 Plug 'mbbill/undotree', {'tag': 'rel_6.1'}
" file icons
Plug 'ryanoasis/vim-devicons'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
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
  colorscheme nord
catch
endtry

set guifont=HackNerdFontCompleteM

set background=dark

" vim hardcodes background color erase even if the terminfo file does
" not contain bce (not to mention that libvte based terminals
" incorrectly contain bce in their terminfo files). This causes
" incorrect background rendering when using a color theme with a
" background color.
let &t_ut=''

" show hidden files in fzf
let $FZF_DEFAULT_COMMAND = 'rg --hidden --glob ''!.git'' -l ""'
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --hidden --column --line-number --no-heading --color=always --smart-case --glob ''!.git/*'' -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" ctrp settings
let g:ctrlp_show_hidden=1

let g:terraform_fmt_on_save=1

if has('nvim')
  " We have to do this to fix a bug with Neovim on OS X where C-h
  " is sent as backspace for some reason.
  nnoremap <BS> <C-W>h
endif

"""""""""""""""""""""""""""
"       ale settings       "
""""""""""""""""""""""""""""
let g:ale_fix_on_save = 1
" end ale "

""""""""""""""""""""""
"     mappings       "
""""""""""""""""""""""
nnoremap <silent> <C-p> :Telescope git_files<CR>
nnoremap <silent> <C-b> :Telescope buffers<CR>
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
  au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
  autocmd BufRead,BufNewFile */templates/*.yaml,*/templates/*.tpl set ft=helm
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=<:> indentkeys-=0# indentkeys-=<:>
  autocmd FileType helm setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=<:> indentkeys-=0# indentkeys-=<:>
augroup END

" using plugin committia in place of this for now
" autocmd VimEnter COMMIT_EDITMSG call OpenCommitMessageDiff()
" function OpenCommitMessageDiff()
"   try
"     " Remove 'vert' if you want it horizontally split.
"     :vert Git diff --cached

"     " Fix-up tmp buffer
"     set filetype=diff noswapfile nomodified readonly
"     silent file [Changes\ to\ be\ committed]

"   endtry

"   " Get back to the commit message
"   wincmd p
" endfunction


" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

if has("nvim")
    " lua require("lsp-config")
    " lua require("compe-config")
    lua require("telescope-config")
endif

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
  indent = {
    enable = true,
  },
}
EOF

