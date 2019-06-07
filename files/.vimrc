set nocompatible              " be iMproved, required
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'Chiel92/vim-autoformat'
Plugin 'ntpeters/vim-better-whitespace'
call vundle#end()            " required

syntax enable
colorscheme molokai
set t_Co=256
set t_ut=
"filetype plugin indent on
filetype plugin on
set tabstop=4
set shiftwidth=4
set expandtab
cmap w!! w !sudo tee > /dev/null %
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

