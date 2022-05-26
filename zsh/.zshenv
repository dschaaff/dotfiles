export EDITOR="nvim"
export GPG_TTY=$(tty)
export FZF_DEFAULT_COMMAND='rg --hidden --glob '!.git' -l ""'
export PATH="/usr/local/sbin:$PATH"
# homebrew m1 mac
export PATH="/opt/homebrew/bin:$PATH"
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
export PATH=/usr/local/opt/python@3.9/bin:$PATH
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
# nvm
# export NVM_DIR="$HOME/.nvm"
#   . "/usr/local/opt/nvm/nvm.sh"
# Add default node to path
export PATH=/Users/danielschaaff/.nvm/versions/node/v14.17.0/bin:$PATH
# Load NVM
export NVM_DIR=/usr/local/opt/nvm/nvm.sh
alias assume="source assume"
