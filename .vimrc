set nocompatible              " be iMproved, required
filetype off

 " set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'morhetz/gruvbox'
Plugin 'itchyny/lightline.vim'
Plugin 'ntpeters/vim-better-whitespace'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'rodjek/vim-puppet'
Plugin 'scrooloose/syntastic'
Plugin 'universal-ctags/ctags'
"Plugin 'ludovicchabant/vim-gutentags'
Plugin 'vimwiki/vimwiki'
Plugin 'majutsushi/tagbar'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-repeat'
Plugin 'xolox/vim-misc'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'preservim/nerdtree'
Plugin 'airblade/vim-gitgutter'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'

call vundle#end()            " required

"Gutentag, put tags file in .git dir
"let g:gutentags_ctags_tagfile = ".git/ctags"

" Leader is \
" Show Tagbar with \t
nnoremap <Leader>t :TagbarOpenAutoClose<CR>
" Surrounding with quotes or brackets
nmap <Leader>' ysiW'
nmap <Leader>" ysiW"
nmap <Leader>[ ysiw}
nmap <Leader>] ysiW}
" Switch windows in vim with alt shift + j/k/l/h
nnoremap <C-A-j> <C-w>j
nnoremap <C-A-l> <C-w>l
nnoremap <C-A-k> <C-w>k
nnoremap <C-A-h> <C-w>h
" Fuzzy find
nnoremap <A-S-f> :Files<CR>

" Syntastic recommended settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" Next and Previous error
nnoremap <Leader>n :lne<CR>
nnoremap <Leader>p :lp<CR>

" Open Vimwiki when no file is being opened
autocmd StdinReadPre * let s:std_in=1
nnoremap <A-S-n> :NERDTreeToggle<CR>
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | execute 'VimwikiIndex' | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Eye candy
syntax enable
colorscheme gruvbox
set background=dark
set t_Co=256 " Multi color support
set termguicolors " Multi color support
" Transparency support
hi Normal guibg=NONE ctermbg=NONE
set nohlsearch " Stop highlighting search results
filetype plugin on
" 4 spaces per tab
set tabstop=2
set shiftwidth=2
set expandtab
" Save with sudo when typing :w!!
cmap w!! w !sudo tee > /dev/null %
" Copy to clipboard on yank
set clipboard=unnamedplus
" Write vim swap file sooner, also helps with git diff tracking
set updatetime=100
" Remove annoying delays
set timeoutlen=1000 ttimeoutlen=0
" Set relative numbers
set number relativenumber
autocmd BufWritePre * %s/\s\+$//e

" Python3 mode
let g:pymode_python = 'python3'
