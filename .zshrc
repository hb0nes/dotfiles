# Plugins
#eval "$(starship init zsh)"
source ~/.config/zsh/powerlevel10k/powerlevel10k.zsh-theme
source ~/.config/zsh/.purepower
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^ ' autosuggest-accept # ctrl space for autocomplete
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Tab menu completion
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'r:|?=** m:{a-z\-}={A-Z\_}'
zmodload zsh/complist
compinit
# Include hidden files in autocomplete:
_comp_options+=(globdots)
setopt extendedglob
setopt GLOB_DOTS

# use the vi navigation keys in menu completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Don't jump too much when using alt B and alt F
export WORDCHARS="*?_[]|~=&!#$%^(){}<>"

# usability
setopt auto_cd
setopt no_beep

# history
alias history="history 0"
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000
setopt SHARE_HISTORY
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.

# Path
export PATH="/home/b0nes/.local/bin:/opt/terraform:/home/b0nes/Personal/scripts:/home/b0nes/Work/terraform:${PATH}:/home/b0nes/go/bin"
export PATH=$PATH:/usr/local/go/bin
export EDITOR=nvim
export VISUAL=nvim

# Aliases
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
alias \
    vpn="sudo openfortivpn" \
    b="bolt command run --targets" \
    r="ranger" \
   	cp="cp -iv" \
    mv="mv -iv" \
    rm="rm -v" \
    mkd="mkdir -pv" \
    ls="lsd" \
    ll="ls --color -lrth" \
    ...='../..' \
    ....='../../..' \
    .....='../../../..' \
    wifi="wicd-curses" \
    img="sxiv -a" \
    sxiv="sxiv -a" \
    m="neomutt" \
    plex="~/Apps/plex" \
    attr="amount=174545; curl -s -X GET 'https://api.coingecko.com/api/v3/simple/price?ids=attrace&vs_currencies=eur' -H 'accept: application/json' | grep -oP '\d+\.\d+' | awk -v amount=\${amount} '{print \$0 * amount}'"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FD_OPTIONS="--follow --exclude .Private --hidden"
export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --type f --type l ${FD_OPTIONS}"
export FZF_DEFAULT_OPTS="--no-mouse --height 50% -1 --reverse --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style full {} || cat {}) 2> /dev/null | head -300' --preview-window='right:wrap:hidden' --bind='f3:execute(bat --style full {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute(echo {+} | xsel -b)'"
export FZF_CTRL_T_COMMAND="fd ${FD_OPTIONS}"
export FZF_ALT_C_COMMAND="fd --type d ${FD_OPTIONS}"

function mux() {
    if [[ "${1}" == "stop" ]]; then
        echo "Stopping tmux."
        tmuxinator stop home
    else
        echo "Starting tmux."
        tmuxinator start home
    fi
}

function fzf_grep_edit(){
    local match files lineno
    if [[ $# == 0 ]]; then
        echo 'Error: search term was not provided.'
        return
    fi
    match=$(
    rg -g "!custom-modules" --no-ignore --color=never --line-number -i --hidden "$1" |
        fzf --delimiter : \
            --preview "bat --style full --line-range {2}: {1}"
      )
    files=$(cut -d':' -f1 <<< "${match}")
    lineno=$(cut -d':' -f2 <<< "${match}")
    if [[ -n "$files" ]]; then
        nvim -p +${lineno} $(paste -s -d ' ' <<<$files)
    fi
}
alias v="fzf_grep_edit"

function wait_for_ssh(){
    local host=$1
    while true; do
        if ping -c1 -w1 "${host}" >/dev/null 2>&1; then
            ssh-add -l && ssh "${host}"
        else
            echo "Host: ${host} unreachable."
        fi
        sleep 1
    done
}

# Git helpers
function gp() {
  local commitMsg=$1
  git add -A; git commit -m "${commitMsg}"; git push
}

function gm() {
  local branch=${1}
  [[ "${branch}" ]] || { echo "Supply a branch name."; exit 1; }
  currentBranch=$(git rev-parse --abbrev-ref HEAD)
  git checkout ${branch}
  git merge ${currentBranch}
  git push
  git checkout ${currentBranch}
}

# CD to directory of file
function cd() {
    [[ -f "$1" ]] && { builtin cd $(dirname $1); return 0; }
    builtin cd $@
}

# Go to git root
function gr() {
  cd $(git rev-parse --show-toplevel)
}

# Get filepath and copy it
function fp() {
  filePath=$(readlink -f $1 | sed -Ez 's/\n+$//')
  echo -n ${filePath} | xsel -b
  [[ $? == 0 ]] && echo "Copied ${filePath} to clipboard." || echo "Copying filepath to clipboard went wrong."
}

alias ds="sudo ncdu -x"
