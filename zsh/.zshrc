# homebrew m1 mac
export PATH="/opt/homebrew/bin:$PATH"
###########
# PLUGINS #
###########
# https://getantidote.github.io/
# update plugins with antidote bundle < ~/.zsh_plugins.txt > .zsh_plugins.zsh
source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
source ~/.zsh_plugins.zsh

export ZSH_AUTOSUGGEST_USE_ASYNC=true
PS1="READY > "


# import 1password plugins
if [ -f "$HOME/.config/op/plugins.sh" ]; then
    source $HOME/.config/op/plugins.sh
fi
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
# setopt SHARE_HISTORY
setopt APPEND_HISTORY
# do not store duplications
setopt HIST_IGNORE_DUPS
#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
alias history="history 1"
HISTSIZE=99999
SAVEHIST=$HISTSIZE

# home, end, and delete keys
bindkey '\e[H' beginning-of-line
bindkey "^[[F"  end-of-line
bindkey "^[[3~" delete-char
# https://github.com/zsh-users/zsh/blob/ac0dcc9a63dc2a0edc62f8f1381b15b0b5ce5da3/NEWS#L37-L42
zle_highlight+=(paste:none)
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
alias k='kubectl'
alias kcl='kubectl'
alias ktl='kubectl'
alias kubectx='switch'
alias kctx='switch'
alias tflock='terraform providers lock -platform=darwin_arm64 -platform=darwin_amd64 -platform=linux_arm64 -platform=linux_amd64'

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
source <(~/.rd/bin/kubectl completion zsh)
complete -F __start_kubectl kcl
complete -F __start_kubectl ktl

complete -C '/opt/homebrew/bin/aws_completer' aws
complete -o nospace -C /usr/local/bin/terraform terraform
complete -o nospace -C /usr/local/bin/vault vault
###################
# END COMPLETIONS #
###################

# _evalcache rbenv init -

autoload -U +X bashcompinit && bashcompinit

# setup zoxide https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init zsh)"

######################################
# SET A HIGHER SOFT ULIMIT FOR SHELL #
######################################

ulimit -Sf unlimited

#############
# FUNCTIONS #
#############
# autoload function files
fpath=( ~/.zshfn "${fpath[@]}" )
autoload -Uz $fpath[1]/*(.:t)
#################
# END FUNCTIONS #
#################

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

##########################################################
# Kubeswitch https://github.com/danielfoehrKn/kubeswitch #
##########################################################
source <(switcher init zsh)
source <(switch completion zsh)
#################
# ENV VARIABLES #
#################
export EDITOR="nvim"
export GPG_TTY=$(tty)
export FZF_DEFAULT_COMMAND='rg --hidden --glob '!.git' -l ""'
# .local/bin is used by pipx
export PATH="$HOME/.local/bin:/usr/local/sbin:$PATH"
# go
export GOPATH=$HOME/go
export GOROOT=/opt/homebrew/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

JAVA_HOME=$(/usr/libexec/java_home)
export JAVA_HOME

# helm
export HELM_EXPERIMENTAL_OCI=1
export KUBEVAL_SCHEMA_LOCATION=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master
# Python
export PATH=/usr/local/opt/python@3.12/bin:$PATH
# Sublime Text
export PATH=/Applications/Sublime\ Text.app/Contents/SharedSupport/bin:$PATH
# Sublime Merge
export PATH=/Applications/Sublime\ Merge.app/Contents/SharedSupport/bin:$PATH
# home directory bin path
export PATH=$HOME/bin:$PATH
# kubectl krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
# rancher desktop nerdctl
export PATH="$HOME/.rd/bin:$PATH"
export PATH="/opt/homebrew/opt/node@18/bin:$PATH"
alias assume="source assume"

# setup starship rs prompt
# set tab title to pwd in wezterm
function set_win_title(){
    # set wezterm title
    echo -ne "\x1b]0; $(basename "$PWD") \x1b\\"
}
precmd_functions+=(set_win_title)
eval "$(starship init zsh)"

# fzf setup
source /opt/homebrew/opt/fzf/shell/key-bindings.zsh

# zsh-history-substring-search configuration
bindkey '^[[A' history-substring-search-up # or '\eOA'
bindkey '^[[B' history-substring-search-down # or '\eOB'
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# atuin.sh
source $HOME/.atuin.zsh
source <(atuin gen-completions --shell zsh)
# setup wezterm shell integration
if [[ -f "$HOME/.dotfiles/wezterm/wezterm.sh" ]] && [[ "$TERM_PROGRAM" == "WezTerm" ]]; then
    source $HOME/.dotfiles/wezterm/wezterm.sh
fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/danielschaaff/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
