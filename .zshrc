eval "$(/opt/homebrew/bin/brew shellenv)"
export GIT_SSH_COMMAND="/usr/bin/ssh"

export TELEPORT_LOGIN=root

#conda init "$(basename "${SHELL}")" >/dev/null
## Plugins
eval "$(starship init zsh)"
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

export EDITOR=vim
export VISUAL=vim

### Tab menu completion
fpath=(~/.zsh $fpath)
autoload -U compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'r:|?=** m:{a-z\-}={A-Z\_}'
zmodload zsh/complist
## Include hidden files in autocomplete:
_comp_options+=(globdots)
setopt extendedglob
setopt GLOB_DOTS
# Path
bindkey -e
bindkey '^ ' autosuggest-accept # ctrl space for autocomplete
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history bindkey -M menuselect 'l' vi-forward-char bindkey -M menuselect 'j' vi-down-line-or-history

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


# Aliases
PATH="/Users/b0nes/Downloads/nvim-macos/bin:${PATH}"
PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
PATH="/opt/tanzu-cli:${PATH}"
PATH="/usr/local/bin:/opt/puppetlabs/bolt/bin:/opt/puppetlabs/pdk/share/cache/ruby/2.7.0/gems/puppet-lint-2.5.2/bin:/opt/homebrew/Cellar/tmuxinator/3.0.5/libexec/gems/tmuxinator-3.0.5/bin/tmuxinator:/Users/b0nes/Work/code/puppet-editor-services:/Users/b0nes/Personal/scripts:/Users/b0nes/Work/code/system-tools:/opt/homebrew/bin:/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/ssh_alias" ] && source "$HOME/.config/ssh_alias"
alias \
    lg="lazygit" \
    vpn='sudo openfortivpn -c /etc/openfortivpn/config --cookie="$(openfortivpn-saml)" -v' \
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
    attr="amount=174545; curl -s -X GET 'https://api.coingecko.com/api/v3/simple/price?ids=attrace&vs_currencies=eur' -H 'accept: application/json' | grep -oP '\d+\.\d+' | awk -v amount=\${amount} '{print \$0 * amount}'" \
    gb="git branch | grep \* | cut -d\  -f2 | sed 's/-/_/g' | tr -d '\n' | tee >(pbcopy)" \
    gs-="git switch -" \
    j="jira-terminal" \
    jlm="jira-terminal list -p SYS -j 'status != Done and status != Rejected' -M" \
    jl="jira-terminal list -p SYS -j 'status != Done and status != Rejected' | less" \
    jc="jira-terminal comment -t" \
    jn="jira-terminal new -M -t Task -P SYS -s" \
    jt="jira-terminal transition"

# tanzu completion
source <(tanzu completion zsh)
compdef _tanzu tanzu


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FD_OPTIONS="--follow --exclude .Private --hidden"
export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --type f --type l ${FD_OPTIONS}"
export FZF_DEFAULT_OPTS="--no-mouse --height 50% -1 --reverse --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style full {} || cat {}) 2> /dev/null | head -300' --preview-window='right:wrap:hidden' --bind='f3:execute(bat --style full {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute(echo {+} | xsel -b)'"
export FZF_CTRL_T_COMMAND="fd ${FD_OPTIONS}"
export FZF_ALT_C_COMMAND="fd --type d ${FD_OPTIONS}"

function mux() {
    if [[ "${1}" == "stop" ]]; then
        echo "Stopping tmux."
        tmuxinator stop work
    elif [[ "${1}" == "restart" ]]; then
        echo "Restarting tmux."
        tmuxinator stop work
        tmuxinator start work
    else
        echo "Starting tmux."
        tmuxinator start work
    fi
}

function fzf_grep_edit(){
    local match files lineno
    if [[ $# == 0 ]]; then
        echo 'Error: search term was not provided.'
        return
    fi
    match=$(
    rg -g "!custom-modules" --no-ignore --color=never --line-number -i --hidden "$1" | sort -t: -k 1,1 -u |
        fzf --delimiter : \
            --preview "bat --style full --line-range {2}: {1}"
      )
    files=$(cut -d':' -f1 <<< "${match}")
    lineno=$(cut -d':' -f2 <<< "${match}")
    if [[ -n "$files" ]]; then
        vim -p +${lineno} $(paste -s -d ' ' <(echo "${files}"))
    fi
}
alias v="fzf_grep_edit"

function wait_for_ssh(){
    local host=$1
    while true; do
        ssh "${host}" || echo "Host: ${host} unreachable."
        #if ping -c1 -W1 "${host}" >/dev/null 2>&1; then
            #ssh-add -l && ssh "${host}"
        #else
        #fi
        sleep 1
    done
}

# Git helpers
alias gdp="git diff production.."
#zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
compdef _git gbr=git-checkout
compdef _git gcb=git-checkout
compdef _git gm=git-checkout
function gbr() {
  [[ $1 ]] || { echo "supply branch"; return 1; }
  : git checkout
  branchName=$1
  git push origin -d ${branchName}
  git branch -d ${branchName}
}
alias gbd="gbr"

function gcb() {
  local branch=$1
  git checkout    ${branch} &>/dev/null && return 0
  git checkout -b ${branch} &>/dev/null && return 0
  return 1
}


# git branch delete merged branches that do not exist remotely
function gbmd() {
  local_branches=$(git branch|tr -d ' '|sort)
  merged_branches=$(git log|grep -oP "(?<=Merge branch ').*?(?=')"|sort)
  remote_branches=$(git ls-remote -qh|awk -F'/' '{print $NF}'|sort)
  merged_branches_not_remote=$(comm -23 <(printf "${merged_branches}") <(printf "${remote_branches}"))
  merged_branches_not_remote_local=$(comm -12 <(printf "${merged_branches_not_remote}") <(printf "${local_branches}"))
  echo "${merged_branches_not_remote_local}"
}

function g() {
 git checkout "$(git branch -a | sed 's|remotes/.*/||' | grep -v HEAD | sort -ru | fzf | tr -d '[:space:]')"

}

function gp() {
  local commitMsg=$1
  git add -A; git commit -m "${commitMsg}"; git push -u
}

function gtp() {
  local commitMsg=$1
  last_tag=$(git tag | tail -1 | sed 's|\.||g')
  incr_tag=$(( last_tag + 1 ))
  new_tag=$(sed 's|\w|&.|g;s|.$||' <<< $incr_tag)
  git add .; git commit -m "${commitMsg}"; git tag $new_tag; git push --tags; git push
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


flushdns() {
  sudo dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
}

export LC_ALL=en_US.UTF-8
source $HOME/.cargo/env
ulimit -n 123123
source <(kubectl completion zsh)
export TELEPORT_ADD_KEYS_TO_AGENT=yes

#source /opt/homebrew/opt/spaceship/spaceship.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

PATH="$HOME/.cargo/bin:$PATH"


govc () {
	GOVC_INSECURE=1 GOVC_URL=https://$(op item get vSphere --fields username | sed s/@/%40/):$(op item get vSphere --fields password)@ld4-vct-02.deribit.internal /opt/homebrew/bin/govc $@
}

govc_login_vm() {
  vm=$1
  [[ $vm ]] || return 1
  username=$(op item get $vm --fields username)
  password=$(op item get $vm --fields password)
  govc vm.keystrokes -vm $vm -s $username
  govc vm.keystrokes -vm $vm -c 0x28
  govc vm.keystrokes -vm $vm -s $password
  govc vm.keystrokes -vm $vm -c 0x28
}

gbp(){
  echo "puppet agent -tE $(gb) --noop" | tee >(pbcopy)
}


ipmi() {
  local h=$1; shift;
  ipmitool -H $h -U ADMIN -P $(op item get $h --fields password) -I lanplus $@
}

ipmireset() {
    ipmi $1 power reset
    ipmi $1 power on
}

ipmibios() {
    ipmi $1 chassis bootdev bios
    ipmi $1 power reset
    ipmi $1 power on
    ipmi $1 sol activate
}

ipmisol() {
    ipmi $1 sol activate
}
