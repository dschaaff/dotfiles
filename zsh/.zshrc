# uncomment to load profiler
# zmodload zsh/zprof

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
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
## https://github.com/zsh-users/zsh-autosuggestions fish like suggestions
export ZSH_AUTOSUGGEST_USE_ASYNC=true
PS1="READY > "
eval "$(starship init zsh)"

# https://github.com/zsh-users/zsh-history-substring-search
zinit ice wait; zinit light zsh-users/zsh-history-substring-search
# fish like syntax highlighting
zinit ice wait; zinit light zdharma/fast-syntax-highlighting
# https://github.com/zsh-users/zsh-autosuggestions fish like suggestions
export ZSH_AUTOSUGGEST_USE_ASYNC=true
zinit ice wait lucid atload'_zsh_autosuggest_start'; zinit light zsh-users/zsh-autosuggestions
zinit ice wait; zinit light 3v1n0/zsh-bash-completions-fallback
zinit ice wait; zinit light zsh-users/zsh-completions
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

# home and end keys
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
##########################
# END Shell Opt SETTINGS #
##########################


###########
# ALIASES #
###########
# Add some colors to grep
alias grep='grep --color=auto'
# terraform switcher
# cdtfswitch(){
#   builtin cd "$@";
#   cdir=$PWD;
#   if [ -f "$cdir/.tfswitchrc" ]; then
#     tfswitch
#   fi
# }
# alias cd='cdtfswitch'
alias ls='ls -G'
alias ll='ls -l'
alias vim='nvim'
alias vi='nvim'
alias kcl='kubectl'
alias ktl='kubectl'

alias consul-dev='CONSUL_HTTP_ADDR=https://consul-ui.dev.cordialdev.com  consul'
alias consul-stg='CONSUL_HTTP_ADDR=https://consul-ui.stg.cordialdev.com consul'
alias consul-prd='CONSUL_HTTP_ADDR=https://consul-ui.ops.cordial.io consul'
alias consul-prd-usw2='CONSUL_HTTP_ADDR=https://consul-ui.us-west-2.cordial.io consul'

alias vault-dev='VAULT_ADDR=https://vault.dev.cordialdev.com:8200 VAULT_CACERT=~/.vault-cli/dev/ca.crt vault'
alias vault-stg='VAULT_ADDR=https://vault.stg.cordialdev.com:8200 VAULT_CACERT=~/.vault-cli/stg/ca.crt vault'
alias vault-prd='VAULT_ADDR=https://vault.ops.cordial.io:8200 VAULT_CACERT=~/.vault-cli/prd/ca.crt vault'
alias vault-prd-usw2='VAULT_ADDR=https://vault.us-west-2.cordial.io:8200 VAULT_CACERT=~/.vault-cli/prd/us-west-2/ca.crt vault'
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
    aws ec2 describe-instances --instance-ids $1 | jq -r '.Reservations[0].Instances[0].PrivateIpAddress'
}

assh() {
    host=$(getec2ip ${1})
    ssh ${host}
}
#################
# END FUNCTIONS #
#################

[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" --no-use

###############
# COMPLETIONS #
###############
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle :compinstall filename '/Users/danielschaaff/.zshrc'
# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
# partial completion suggestions
zstyle ':completion:*' list-suffixeszstyle ':completion:*' expand prefix suffix

autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
zinit cdreplay -q
# End of lines added by compinstall
source <(kubectl completion zsh)
complete -F __start_kubectl kcl
complete -F __start_kubectl ktl

complete -C '/usr/local/bin/aws_completer' aws
complete -o nospace -C /usr/local/bin/vault vault
###################
# END COMPLETIONS #
###################

_evalcache rbenv init -
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# To customize prompt, run `p10k configure` or edit ~/.dotfiles/zsh/.p10k.zsh.
#[[ ! -f ~/.dotfiles/zsh/.p10k.zsh ]] || source ~/.dotfiles/zsh/.p10k.zsh

autoload -U +X bashcompinit && bashcompinit
