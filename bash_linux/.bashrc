[[ $- != *i* ]] && return

export EDITOR="nvim"
export VISUAL="nvim"

alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias cat="bat -pp --theme ansi"
alias vim="nvim"

export PATH=$HOME/go/bin:$PATH
. "$HOME/.cargo/env"

eval "$(starship init bash)"
eval "$(zoxide init --cmd cd bash)"

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
