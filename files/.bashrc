# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

function mux()
{
    COMMAND=""
    [[ "$1" = stop ]] && COMMAND="tmuxinator stop work"
    [[ -z "$1" ]] && COMMAND="tmuxinator start work"
    eval $COMMAND
    [[ ! -z "$1" && ! "$1" = stop ]] && echo "Usage: $0 [stop]"
}

export PATH=$PATH:~/scripts
