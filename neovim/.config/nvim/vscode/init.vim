" set runtimepath^=~/.config/nvim/vscode runtimepath+=~/.config/nvim/vscode/after
" let &packpath = &runtimepath
" Install vim-plug if not found
if empty(glob('~/.config/nvim/vscode/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/vscode/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
let mapleader = ","
call plug#begin('~/.config/nvim/vscode/plugged')
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
call plug#end()
" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif
