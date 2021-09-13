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

[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" --no-use

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

#############
# FUNCTIONS #
#############
# autoload function files
fpath=( ~/.zshfn "${fpath[@]}" )
autoload -Uz $fpath[1]/*(.:t)
#################
# END FUNCTIONS #
#################
