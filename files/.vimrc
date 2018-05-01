set nocompatible              " be iMproved, required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'Valloric/YouCompleteMe'
Plugin 'Chiel92/vim-autoformat'
Plugin 'VundleVim/Vundle.vim'
call vundle#end()            " required
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'

syntax enable
colorscheme molokai
set t_Co=256
set t_ut=
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
