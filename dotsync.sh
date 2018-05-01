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
    #Install ZSH
    sudo apt-get install zsh
    #Install Oh-my-ZSH!
    sudo sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
} 

function pull {
    git fetch > /dev/null 2>&1
    echo "Fetching."
    git pull > /dev/null 2>&1
    echo "Pulling."
    mv $DIR/.oh-my-wtf $DIR/.oh-my-zsh > /dev/null 2>&1
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
    mv $DIR/.oh-my-zsh $DIR/.oh-my-wtf > /dev/null 2>&1
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
    mv $DIR/.oh-my-zsh $DIR/.oh-my-wtf > /dev/null 2>&1
    echo "Copied all dotfiles to $DIR. Now let's commit and push."
    git add -A
    echo "Added."
    git commit -a --allow-empty-message -m '' > /dev/null #2>&1
    echo "Committed."
    git push > /dev/null #2>&1
    echo "Pushed."
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
