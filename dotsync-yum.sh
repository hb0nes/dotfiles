#!/bin/bash -e
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
    if [[ ${force} == "force" ]]; then
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
    sudo yum update
    sudo yum groupinstall -y development
    sudo yum install -y ruby ruby-devel lua lua-devel luajit ctags git python python-devel python36 python36-devel tcl-devel perl-devel perl-ExtUtils-ParseXS perl-ExtUtils-CBuilder gcc cmake make automake autoconf openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel https://centos7.iuscommunity.org/ius-release.rpm yum-utils ncurses-devel glibc-static libevent-devel zsh tmux
    installRuby

    #Install tmux, tmuxinator, zsh, vim80 with youcompleteme plugin
    if [[ ! -f /usr/local/bin/tmuxinator || $force == 'force' ]]; then
        sudo gem update
        sudo gem update --system
        sudo gem install tmuxinator else
        echo "Already have Tmuxinator installed."
    fi
    if [[ ! -f /bin/zsh || $force == 'force' ]]; then
        #echo "zsh" >> $HOME/.bashrc
        :
    else
        echo "Already have ZSH installed."
    fi
    if [[ ! -d /usr/local/share/vim/vim81 || $force == 'force' ]]; then
        installVim
    else
        echo "Already have ViM81 installed."
    fi

    installVundle
    chsh -s /bin/zsh root

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
    PYTHONCONFIGDIR=$(find /usr/lib64 /usr/lib -iname "config-*" -type d)
    echo "Python config dir: ${PYTHONCONFIGDIR}"
    #Delete current vim
    sudo yum remove -y vim vim-runtime gvim
    sudo rm -rf /usr/local/share/vim /usr/local/bin/vim /usr/bin/vim
    #Clone vim repo, configure and make
    cd ${HOME}
    sudo rm -rf vim
    git clone https://github.com/vim/vim.git
    cd vim
    sudo ./configure --with-features=huge \
        --enable-multibyte \
        --enable-python3interp=yes \
        --with-python3-config-dir=${PYTHONCONFIGDIR} \
        --enable-gui=gtk2 \
        --enable-cscope \
        --prefix=/usr/local
    make VIMRUNTIMEDIR=/usr/local/share/vim/vim81
    #Install that shit
    sudo make install

    # Cleanup
    sudo rm -rf $HOME/vim
    echo "All done!"
}

installRuby(){
    if [[ ! -f /usr/local/rvm/rubies/ruby-head/bin/ruby && ! -L /usr/bin/ruby ]]; then
      echo "Installing latest Ruby and RVM."
      curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
      curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
      curl -L get.rvm.io | bash -s stable
      sudo usermod -a -G rvm root
      sudo usermod -a -G rvm ${USER}
      source /etc/profile.d/rvm.sh
      rvm reload
      rvm requirements run
      rvm install ruby-head
      rm -rf /usr/bin/ruby
      ln -s /usr/local/rvm/rubies/ruby-head/bin/ruby /usr/bin/ruby
    else
      echo "Ruby already installed."
    fi
}

installVundle(){
    # Install Vundle
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
    $HOME/.vim/bundle/YouCompleteMe/install.py --clang-completer
    # Do it all for root as well
    #sudo git clone https://github.com/VundleVim/Vundle.vim.git /root/.vim/bundle/Vundle.vim
    #sudo su -c "vim +PluginInstall +qall"
    #sudo /root/.vim/bundle/YouCompleteMe/install.py --clang-completer
}

if [[ $# == 0 ]]; then usage; fi
while [[ $# > 0 ]]; do
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
