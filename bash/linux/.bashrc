[[ $- != *i* ]] && return

export EDITOR="nvim"
export VISUAL="nvim"

alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias cat="bat -pp --theme ansi"
alias vim="nvim"

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
