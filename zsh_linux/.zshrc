# oh-my zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git fzf zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

export PATH=$HOME/go/bin:$PATH
. "$HOME/.cargo/env"

export EDITOR="nvim"
export VISUAL="nvim"

export FZF_DEFAULT_OPTS="--color=bg+:-1,gutter:-1"

alias cat="bat -pp --theme ansi"
alias vim="nvim"

eval "$(starship init zsh)"

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
