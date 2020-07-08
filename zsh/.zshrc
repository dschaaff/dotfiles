# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
# autoload -Uz _zinit
# (( ${+_comps} )) && _comps[zinit]=_zinit
autoload -Uz compinit && compinit
# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

###########
# PLUGINS #
###########
PS1="READY > "
## https://github.com/zsh-users/zsh-history-substring-search
zinit ice wait; zinit light zsh-users/zsh-history-substring-search
## fish like syntax highlighting
zinit ice wait; zinit light zdharma/fast-syntax-highlighting
## https://github.com/zsh-users/zsh-autosuggestions fish like suggestions
export ZSH_AUTOSUGGEST_USE_ASYNC=true
zinit ice wait lucid atload'_zsh_autosuggest_start'; zinit light zsh-users/zsh-autosuggestions
# jq repl to help figure out expressions
zinit ice wait; zinit light reegnz/jq-zsh-plugin
zinit ice depth=1; zinit ice wait; zinit light 3v1n0/zsh-bash-completions-fallback
zinit ice wait; zinit light zsh-users/zsh-completions
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light mroth/evalcache

###############
# END PLUGINS #
###############

######################
# Shell Opt SETTINGS #
######################
# save history between terminal closes
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
# adds commands as they are typed, not at shell exit
# setopt INC_APPEND_HISTORY
# do not store duplications
setopt HIST_IGNORE_DUPS
#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
##########################
# END Shell Opt SETTINGS #
##########################


###########
# ALIASES #
###########
# Add some colors to grep
alias grep='grep --color=auto'
# terraform switcher
cdtfswitch(){
  builtin cd "$@";
  cdir=$PWD;
  if [ -f "$cdir/.tfswitchrc" ]; then
    tfswitch
  fi
}
alias cd='cdtfswitch'
alias ls='ls -G'
alias ll='ls -l'
alias vim='nvim'
alias vi='nvim'
alias kcl='kubectl'
alias ktl='kubectl'

alias consul-dev='CONSUL_HTTP_ADDR=https://consul-ui.dev.cordialdev.com  consul'
alias consul-stg='CONSUL_HTTP_ADDR=https://consul-ui.stg.cordialdev.com consul'
alias consul-prd='CONSUL_HTTP_ADDR=https://consul-ui.ops.cordial.io consul'

alias vault-dev='VAULT_ADDR=https://vault.dev.cordialdev.com:8200 VAULT_CACERT=~/.vault-cli/dev/ca.crt vault'
alias vault-stg='VAULT_ADDR=https://vault.stg.cordialdev.com:8200 VAULT_CACERT=~/.vault-cli/stg/ca.crt vault'
alias vault-prd='VAULT_ADDR=https://vault.ops.cordial.io:8200 VAULT_CACERT=~/.vault-cli/prd/ca.crt vault'
###############
# END ALIASES #
###############

#############
# FUNCTIONS #
#############
# NOTE: consider moving these to separate files in the fpath
# Tests if a command is available within the PATH
command_exists () {
    type "$1" &> /dev/null ;
}

# Figure out my public IP
public_ip () {
    if command_exists lynx ; then
        lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | awk '{ print $4 }' | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g'
    elif command_exists wget ; then
        wget -qO- http://checkip.dyndns.org:8245/ | sed 's/[^0-9.]//g;'
    else
        curl -s http://checkip.dyndns.org:8245/ | sed 's/[^0-9.]//g;'
    fi
}

# Regular Date to Unix Timestamp
if command_exists ruby ; then
    date2unix() {
        local raw_date="$@"
        ruby -e "require 'time'; puts Time.parse(\"$raw_date\").to_i"
    }
fi

# Define a word
if command_exists curl ; then
    define() {
        curl dict://dict.org/d:"$@"
    }
fi

# Funny Stuff
look_busy () {
    cat /dev/urandom | hexdump -C | grep --color=auto "ca fe"
}

# Flush DNS cache
flush_dns() {
    sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
}

# Figure out what's got open files... takes a while to run
too_many_open_files() {
  lsof | awk '{ print $1 }' | sort | uniq -c | sort -n
}

getec2ip() {
    aws ec2 describe-instances --instance-ids $1 | jq [.Reservations[0].Instances[0].PrivateIpAddress] | jq --raw-output .[]
}

assh() {
    host=$(getec2ip ${1})
    ssh ${host}
}
#################
# END FUNCTIONS #
#################

#############
# VARIABLES #
#############
export EDITOR="nvim"
export GPG_TTY=$(tty)
export NVM_DIR="$HOME/.nvm"
  . "/usr/local/opt/nvm/nvm.sh"
export FZF_DEFAULT_COMMAND='rg --hidden --glob '!.git' -l ""'
# go
export GOPATH=$HOME/go
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

JAVA_HOME=$(/usr/libexec/java_home)
export JAVA_HOME
# Python
export PATH=$(brew --prefix python)/bin:$PATH
# Sublime Text
export PATH=/Applications/Sublime\ Text.app/Contents/SharedSupport/bin:$PATH
# Sublime Merge
export PATH=/Applications/Sublime\ Merge.app/Contents/SharedSupport/bin:$PATH
# home directory bin path
export PATH=$HOME/bin:$PATH
#################
# END VARIABLES #
#################

###################
# PROMPT SETTINGS #
###################
# function powerline_precmd() {
#     eval "$($GOPATH/bin/powerline-go -error $?  -theme ~/.profile.d/powerline-theme/default.json -shell zsh -modules "aws,kube,newline,venv,ssh,cwd,perms,jobs,newline,exit,root" -eval -modules-right git,time)"
# }

# function install_powerline_precmd() {
#   for s in "${precmd_functions[@]}"; do
#     if [ "$s" = "powerline_precmd" ]; then
#       return
#     fi
#   done
#   precmd_functions+=(powerline_precmd)
# }

# if [ "$TERM" != "linux" ]; then
#     install_powerline_precmd
# fi

#######################
# END PROMPT SETTINGS #
######################## The following lines were added by compinstall
###############
# COMPLETIONS #
###############
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle :compinstall filename '/Users/danielschaaff/.zshrc'

autoload -Uz compinit
compinit
zinit cdreplay -q
# End of lines added by compinstall
###################
# END COMPLETIONS #
###################

_evalcache rbenv init -
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
