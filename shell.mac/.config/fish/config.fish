if status is-interactive
end

abbr -a vim nvim

if command -v bat > /dev/null
    abbr -a cat 'bat'
end

if command -v eza > /dev/null
    abbr -a l 'eza'
    abbr -a ls 'eza'
    abbr -a ll 'eza -l'
    abbr -a la 'eza -la'
else
    abbr -a l 'ls'
    abbr -a ll 'ls -l'
    abbr -a la 'ls -la'
end

fish_add_path '/opt/homebrew/bin'
fish_add_path 'go/bin'
fish_add_path '.cargo/bin'
fish_add_path '.zvm/self'
fish_add_path '.zvm/bin'

set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'

set fish_color_command 'green'
set fish_color_error 'red'

function fish_prompt
    set_color brblack
    echo -n "["(date "+%H:%M")"] "
    set_color green
    echo -n $USER
    set_color red
    echo -n '@'
    set_color blue
    echo -n (hostname -s)
    if [ $PWD != $HOME ]
        set_color brblack
        echo -n ':'
        set_color yellow
        echo -n (basename $PWD)
    end
    set_color green
    printf '%s ' (__fish_git_prompt)
    set_color red
    echo -n '| '
    set_color normal
end

function fish_greeting
    echo
    echo -e " \\e[1mHello there! 👋\\e[0m"
    echo
    echo -e (uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
    echo -e (hostname -s | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
    echo
end
