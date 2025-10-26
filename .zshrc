ulimit -n 65535

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git zsh-completions zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

setopt no_nomatch