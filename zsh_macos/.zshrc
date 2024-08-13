# oh-my zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git fzf zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# homebrew
export PATH=/opt/homebrew/bin:$PATH

# go
export PATH=$PATH:$HOME/go/bin

# rust
. "$HOME/.cargo/env"

# zig
export ZVM_INSTALL="$HOME/.zvm/self"
export PATH="$PATH:$HOME/.zvm/bin"
export PATH="$PATH:$ZVM_INSTALL/"

export EDITOR="nvim"
export VISUAL="nvim"

export FZF_DEFAULT_OPTS="--color=bg+:-1,gutter:-1"

alias cat="bat -pp --theme gruvbox-dark"
alias vim="nvim"

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/oh-my-posh.toml)"
