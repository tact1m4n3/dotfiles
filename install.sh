PLATFORM="$(uname)"

install_dotfiles() {
    if [[ "$PLATFORM" == "Linux" ]]; then
        stow bash_linux
        stow common
        stow hyprland
    elif [[ "$PLATFORM" == "Darwin" ]]; then
        stow bash_macos
        stow common
    fi
}

remove_dotfiles() {
    if [[ "$PLATFORM" == "Linux" ]]; then
        stow -D bash_linux
        stow -D common
        stow -D hyprland
    elif [[ "$PLATFORM" == "Darwin" ]]; then
        stow -D bash_macos
        stow -D common
    fi
}

if [[ $1 == "install_dotfiles" ]]; then
    install_dotfiles
elif [[ $1 == "remove_dotfiles" ]]; then
    remove_dotfiles
else
    echo "usage: $0 install_dotfiles|remove_dotfiles"
    exit 1
fi
