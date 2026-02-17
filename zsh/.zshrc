# homebrew m1 mac
export PATH="/opt/homebrew/bin:$PATH"
###########
# PLUGINS #
###########
# https://getantidote.github.io/
export ZSH_AUTOSUGGEST_USE_ASYNC=true
source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh

# Ensure zsh-completions is in fpath before compinit
fpath=($(antidote path zsh-users/zsh-completions)/src $fpath)

###############
# COMPLETIONS #
###############
# zstyle settings must be configured BEFORE compinit
zstyle ':completion:*' completer _extensions _expand _complete _ignored _correct _approximate
zstyle :compinstall filename '/Users/danielschaaff/.zshrc'
# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
# partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix
# Allow you to select in a menu
zstyle ':completion:*' menu select
# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true
zstyle ':completion:*' file-sort modification
# color output
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Initialize completion system BEFORE loading plugins (required for fzf-tab)
autoload -Uz compinit && compinit

# Now load plugins - fzf-tab will work since compinit already ran
antidote load

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
alias tflock='tofu providers lock -platform=darwin_arm64 -platform=linux_arm64 -platform=linux_amd64'
alias terraform='tofu'

if [ -f "$HOME/.cordial.sh" ]; then
    source $HOME/.cordial.sh
fi
###############
# END ALIASES #
###############

# [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" --no-use

#########################
# ADDITIONAL COMPLETIONS #
#########################
autoload bashcompinit && bashcompinit
source <(~/.rd/bin/kubectl completion zsh)
complete -F __start_kubectl kcl
complete -F __start_kubectl ktl
complete -C '/opt/homebrew/bin/aws_completer' aws
complete -o nospace -C /usr/local/bin/terraform terraform
complete -o nospace -C /usr/local/bin/vault vault
_evalcache logcli --completion-script-zsh
#############################
# END ADDITIONAL COMPLETIONS #
#############################

# _evalcache rbenv init -

# setup zoxide https://github.com/ajeetdsouza/zoxide
_evalcache zoxide init zsh

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
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
# tofu/terraform
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
if [[ -f "$HOME/.krew/bin" ]]; then
  export PATH="$HOME/.krew/bin:$PATH"
fi
alias assume="source assume"

# setup starship rs prompt
# set tab title to pwd in wezterm
# function set_win_title(){
#     # set wezterm title
#     echo -ne "\x1b]0; $(basename "$PWD") \x1b\\"
# }
# precmd_functions+=(set_win_title)
_evalcache starship init zsh

# fzf setup - provides Ctrl+T (file search) and Alt+C (cd)
# Note: fzf's Tab completion is disabled in favor of fzf-tab
if type fzf &>/dev/null; then
    source <(fzf --zsh)
    # Rebind Tab to fzf-tab (fzf --zsh overwrites it with fzf-completion)
    bindkey '^I' fzf-tab-complete
    # Rebind Ctrl+R to atuin (fzf --zsh overwrites it with fzf-history-widget)
    bindkey -M emacs '^r' atuin-search
    bindkey -M viins '^r' atuin-search-viins
else
    echo ERROR: Could not load fzf shell integration.
fi

# zsh-history-substring-search configuration
# Using Ctrl+P/N to avoid conflict with Atuin's up/down arrow bindings
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# setup wezterm shell integration
# if [[ -f "$HOME/.dotfiles/wezterm/wezterm.sh" ]] && [[ "$TERM_PROGRAM" == "WezTerm" ]]; then
#     source $HOME/.dotfiles/wezterm/wezterm.sh
# fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/danielschaaff/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
