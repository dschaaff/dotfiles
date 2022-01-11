###########
# PLUGINS #
###########
# https://getantibody.github.io/
# update plugins with antibody bundle < plugins.txt > .zsh_plugins.sh
## https://github.com/zsh-users/zsh-autosuggestions fish like suggestions
export ZSH_AUTOSUGGEST_USE_ASYNC=true
PS1="READY > "
eval "$(starship init zsh)"

source ~/.zsh_plugins.sh
###############
# END PLUGINS #
###############

######################
# Shell Opt SETTINGS #
######################
bindkey -e
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

# use ctrl f to jump into tmux sessions
bindkey -s ^f "tmux-sessionizer\n"

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

if [ -f "$HOME/.cordial.sh" ]; then
    source $HOME/.cordial.sh
fi
###############
# END ALIASES #
###############

# [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" --no-use

###############
# COMPLETIONS #
###############
zstyle ':completion:*' completer _extensions _expand _complete _ignored _correct _approximate
zstyle :compinstall filename '/Users/danielschaaff/.zshrc'

# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# partial completion suggestions
zstyle ':completion:*' list-suffixeszstyle ':completion:*' expand prefix suffix

# Allow you to select in a menu
zstyle ':completion:*' menu select

# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true

zstyle ':completion:*' file-sort modification

# color output
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
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

autoload -U +X bashcompinit && bashcompinit

#############
# FUNCTIONS #
#############
# autoload function files
fpath=( ~/.zshfn "${fpath[@]}" )
autoload -Uz $fpath[1]/*(.:t)
#################
# END FUNCTIONS #
#################
