[[ $- != *i* ]] && return

export EDITOR="nvim"
export VISUAL="nvim"

alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias cat="bat -pp --theme ansi"
alias vim="nvim"

eval "$(starship init bash)"
eval "$(zoxide init --cmd cd bash)"
