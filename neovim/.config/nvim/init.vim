:let mapleader = ","
if exists('g:vscode')
        source ~/.config/nvim/vscode/init.vim
else
        set runtimepath^=~/.vim runtimepath+=~/.vim/after
        let &packpath = &runtimepath
        source ~/.vimrc
endif
