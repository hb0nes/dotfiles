#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/files"
function usage() {
    echo "Usage: $0 [-h --help] [-d --download] [-u --upload] [-f --first-time <force>] [-t --test] 1>&2"
    exit 1
}

function help() {
    echo "-f or --first-time when you want to install everything on a new machine."
    echo "-f force or --first-time force when you want to overwrite previous attempts."
    echo "-d or --download when you want to sync the dotfiles with the repo."
    echo "-u or --upload when you made local changes and want to push them to the repo."
    exit 1
}

function testRun() {
    echo $@
    echo $DIR
}

function firstTime() {
    if [[ $force == "force" ]]; then
        echo 'Forced install.'
    fi

    sudo git fetch > /dev/null
    sudo git pull > /dev/null

    for file in $(cat $DIR/../filelist); do
        sudo cp -r $DIR/$file $HOME
        sudo cp -r $DIR/$file /root/
        echo "Copied $DIR/$file to home ($HOME)"
    done
    mkdir -p $HOME/school
    echo "Done copying files to your home ($HOME)."

    # Dependencies
    sudo apt update
    sudo apt-get install -y libncurses5-dev libgnome2-dev libgnomeui-dev \
        libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
        libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
        python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev checkinstall build-essential cmake --fix-missing > /dev/null

    #Install tmux, tmuxinator, zsh, vim80 with youcompleteme plugin
    if [[ ! -f /usr/bin/tmux || $force == 'force' ]]; then
        sudo apt-get install -y tmux > /dev/null
    else
        echo "Already have tmux installed."
    fi
    if [[ ! -f /usr/local/bin/tmuxinator || $force == 'force' ]]; then
        sudo gem install tmuxinator
    else
        echo "Already have Tmuxinator installed."
    fi
    if [[ ! -f /bin/zsh5 || $force == 'force' ]]; then
        sudo apt-get install -y zsh > /dev/null
    else
        echo "Already have ZSH installed."
    fi
    if [[ ! -d /usr/local/share/vim/vim80 || $force == 'force' ]]; then
        installVim
    else
        echo "Already have ViM80 installed."
    fi
    #Make YouCompleteMe with Python3.5
    sudo $HOME/.vim/bundle/YouCompleteMe/install.py --clang-completer
    sudo /root/.vim/bundle/YouCompleteMe/install.py --clang-completer
    sleep 2
    echo "All done! Please restart your terminal."
}

function download() {
    sudo git fetch > /dev/null 2>&1
    echo "Fetching."
    sudo git pull > /dev/null 2>&1
    echo "Pulling."
    read -p "Pull all dotfiles?" -n 1 ans
    echo
    for file in $(cat filelist); do
        if [[ $ans =~ ^[YyJj]$ ]]; then
            cp -r $DIR/$file $HOME
            sudo cp -r $DIR/$file /root/
            echo "Copied $DIR/$file to home ($HOME)"
        else
            read -p "Pull $DIR/$file?" -n 1 -r
            echo
            if [[ $REPLY =~ ^[YyJj]$ ]]; then
                sudo cp -r $DIR/$file $HOME
            fi
        fi
    done
    zsh
}

function upload() {
    read -p "Push all dotfiles?" -n 1 ans
    echo
    for file in $(cat filelist); do
        if [[ $ans =~ ^[YyJj]$ ]]; then
            sudo cp -r $HOME/$file $DIR
            echo "Copied $file to $DIR"
        else
            read -p "Push $HOME/$file?" -n 1 -r
            echo
            if [[ $REPLY =~ ^[YyJj]$ ]]; then
                sudo cp -r $HOME/$file $DIR
            fi
        fi
    done
    echo "Copied all dotfiles to $DIR. Now let's commit and push."
    sudo git add -A
    echo "Added."
    sudo git commit -a --allow-empty-message -m '' > /dev/null #2>&1
    echo "Committed."
    sudo git push > /dev/null #2>&1
    echo "Pushed."
}

function installVim() {
    # install dependencies
    PYTHONCONFIGDIR=$(ls /usr/lib/python3.5/ | grep -i config | grep -v ".py")
    echo "Python 3.5 config dir: ${PYTHONCONFIGDIR}"
    #Make Python 3.5 Default:
    sudo rm /usr/bin/python
    sudo ln -s /usr/bin/python3.5 /usr/bin/python
    #Delete current vim
    sudo apt remove -y vim vim-runtime gvim
    #Clone vim repo, configure and make
    cd $HOME
    sudo rm -rf vim
    git clone https://github.com/vim/vim.git
    cd vim
    sudo ./configure --with-features=huge \
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
    #Install that shit
    echo -e "\n\n\n\n\n" | sudo checkinstall
    # Cleanup
    sudo rm -rf $HOME/vim
    # make sure ZSH starts even on Win10 WSL
    echo "zsh" >> $HOME/.bashrc
    echo "All done!"
}

if [[ $# == 0 ]]; then usage; fi
while [[ $# > 1 ]]; do
    key=$1
    case $key in
        -d|--download)
            download
            shift # key
            ;;
        -u|--upload)
            upload
            shift # key
            ;;
        -f|--first-time)
            force=$2
            firstTime $force
            shift # key
            shift # value
            ;;
        -t|--test)
            testRun $@
            shift $# # key
            ;;
        -h|--help)
            help
            ;;
        *)
            usage
            ;;
    esac
done

