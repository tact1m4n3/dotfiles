# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

autoload -U promptinit; promptinit
prompt pure

alias ll="ls -l"
alias la="ls -la"

alias cat="bat -pp --theme Catppuccin-mocha"
alias vim="nvim"

. "$HOME/.cargo/env"
