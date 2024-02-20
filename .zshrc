# TODO: maybe figure out another way to do this
if [[ "$(uname -s)" == "Darwin" ]]; then
    export PATH=/opt/homebrew/bin:$PATH
fi

export ZSH="$HOME/.oh-my-zsh"
export EDITOR=nvim

ZSH_THEME="robbyrussell"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
)

source $ZSH/oh-my-zsh.sh

alias ll="ls -l"
alias la="ls -la"

alias cat="bat -pp --theme ansi"
alias vim="nvim"

. "$HOME/.cargo/env"

eval "$(zoxide init --cmd cd zsh)"
