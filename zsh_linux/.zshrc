# oh-my zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
plugins=(git fzf zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# go
export PATH=$HOME/go/bin:$PATH

# rust
. "$HOME/.cargo/env"

# zvm
export ZVM_INSTALL="$HOME/.zvm/self"
export PATH="$PATH:$HOME/.zvm/bin"
export PATH="$PATH:$ZVM_INSTALL/"

export EDITOR="nvim"
export VISUAL="nvim"

export FZF_DEFAULT_OPTS="--color=bg+:-1,gutter:-1"

alias cat="bat -pp --theme gruvbox-dark"
alias vim="nvim"

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/oh-my-posh.toml)"

if [[ "$(tty)" == *"pts"* ]]; then
    pfetch
else
    if [ -f /bin/hyprctl ]; then
        echo "Starting Hyprland..."
        Hyprland
    else
        echo "Hyprland not found..."
    fi
fi
