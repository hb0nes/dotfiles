#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/files"
if [[ $1 != "pull" && $1 != "push" && $1 != "first-time" && $1 != "debug" ]]; then
    echo "Usage: install.sh <pull/push/first-time>"
    echo "Use first-time when you haven't even installed zsh/oh-my-zsh yet."
    exit
fi

function debug {
    echo $DIR
}

function first-time {
    git fetch > /dev/null
    git pull > /dev/null 

    for file in $(cat filelist); do
        cp -r $DIR/$file ~
        echo "Copied $DIR/$file to home (~)"
    done
    echo "Done copying files to your home (~)."
    echo -e "The following wizard will ask you to install stuff in this order: \n1.TMUX\n2.ZSH\n3.ViM8"
    #Install tmux
    read -p "Do you want to install TMUX?" -r -n 1
    if [[ $REPLY =~ ^[YyJj]$ ]]; then
        sudo apt-get install -y tmux 1>/dev/null
    fi
    #Install ZSH
    read -p "Do you want to install ZSH?" -r -n 1
    if [[ $REPLY =~ ^[YyJj]$ ]]; then
        sudo apt-get install -y zsh 1>/dev/null
    fi
    #Install ViM8 
    read -p "Do you want to install ViM 8 with Python3.5 and YouCompleteMe (autocompletion) support? Please note this will take a long time on most systems." -r -n 1
    if [[ $REPLY =~ ^[YyJj]$ ]]; then
        installVim
    fi
} 

function pull {
    git fetch > /dev/null 2>&1
    echo "Fetching."
    git pull > /dev/null 2>&1
    echo "Pulling."
    read -p "Pull all dotfiles?" -n 1 ans
    echo
    for file in $(cat filelist); do
        if [[ $ans =~ ^[YyJj]$ ]]; then
            cp -r $DIR/$file ~
            echo "Copied $DIR/$file to home (~)"
        else
            read -p "Pull $DIR/$file?" -n 1 -r
            echo
            if [[ $REPLY =~ ^[YyJj]$ ]]; then
                cp -r $DIR/$file ~
            fi
        fi
    done
    zsh
}

function push {
    read -p "Push all dotfiles?" -n 1 ans 
    echo
    for file in $(cat filelist); do
        if [[ $ans =~ ^[YyJj]$ ]]; then
            cp -r ~/$file $DIR
            echo "Copied $file to $DIR"
        else
            read -p "Push ~/$file?" -n 1 -r
            echo
            if [[ $REPLY =~ ^[YyJj]$ ]]; then
                cp -r ~/$file $DIR
            fi
        fi
    done
    echo "Copied all dotfiles to $DIR. Now let's commit and push."
    git add -A
    echo "Added."
    git commit -a --allow-empty-message -m '' > /dev/null #2>&1
    echo "Committed."
    git push > /dev/null #2>&1
    echo "Pushed."
}
function installVim{
    # install dependencies
    sudo apt install -y libncurses5-dev libgnome2-dev libgnomeui-dev \
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
    python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git checkinstall

    PYTHONCONFIGDIR=$(ls /usr/lib/python3.5/ | grep -i config | grep -v ".py")
    echo "Python 3.5 config dir: ${PYTHONCONFIGDIR}"
    #Make Python 3.5 Default:
    sudo rm /usr/bin/python
    sudo ln -s /usr/bin/python3.5 /usr/bin/python
    #Delete current vim
    sudo apt remove -y vim vim-runtime gvim
    #Clone vim repo, configure and make
    cd ~
    rm -r vim
    git clone https://github.com/vim/vim.git
    cd vim
    ./configure --with-features=huge \
                                --enable-multibyte \
                                --enable-rubyinterp=yes \
                                --enable-python3interp=yes \
                                --with-python3-config-dir=$PYTHONCONFIGDIR
                                --enable-perlinterp=yes \
                                --enable-luainterp=yes \
                                --enable-gui=gtk2 \
                                --enable-cscope \
                                --prefix=/usr/local
    make VIMRUNTIMEDIR=/usr/local/share/vim/vim80
    echo -e "\n\n\n\n\n" | checkinstall &
    sleep 10
    #Make YouCompleteMe with Python3.5
    cd ~/.vim/bundle/YouCompleteMe    
    ./install.py --clang-completer

    rm -r ~/vim
    echo "All done!"
}

if [[ $1 == 'push' ]]; then
    push
fi

if [[ $1 == 'pull' ]]; then
    pull
fi

if [[ $1 == 'first-time' ]]; then
    first-time 
    pull
fi

if [[ $1 == 'debug' ]]; then
    debug
fi
