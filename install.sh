#!/bin/bash
if [ $1 == 'install' ]; then
    #Install ZSH
    sudo apt-get install zsh
    #Install Oh-my-ZSH!
    sudo sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    #Install decent LS_COLORS
    wget https://raw.github.com/trapd00r/LS_COLORS/master/LS_COLORS -O $HOME/.dircolors
    echo 'eval $(dircolors -b $HOME/.dircolors)' >> $HOME/.zshrc
    . $HOME/.zshrc
    #Copy vim theme (monokai.vim)
    mkdir -p ~/.vim/colors/
    cp monokai.vim ~/.vim/colors/
    #Copy some dotfiles
    cp .vimrc .tmux.conf .zshrc ~
    source .zshrc
