export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
)

source $ZSH/oh-my-zsh.sh

export EDITOR="nvim"
export VISUAL="nvim"

alias cat="bat -pp --theme ansi"
alias vim="nvim"

export PATH=/usr/local/go/bin:$PATH
. "$HOME/.cargo/env"

# best ever theme
export FZF_DEFAULT_OPTS="--color=bg+:-1,gutter:-1"

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
