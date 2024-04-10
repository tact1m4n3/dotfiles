PLATFORM="$(uname)"

install_base_dotfiles() {
    if [[ "$PLATFORM" == "Linux" ]]; then
        stow bash_linux
    elif [[ "$PLATFORM" == "Darwin" ]]; then
        stow bash_macos
    fi
    stow base
}

install_hypr_dotfiles() {
    if [[ "$PLATFORM" == "Linux" ]]; then
        stow hyprland
    fi
}

remove_base_dotfiles() {
    if [[ "$PLATFORM" == "Linux" ]]; then
        stow -D bash_linux
    elif [[ "$PLATFORM" == "Darwin" ]]; then
        stow -D bash_macos
    fi
    stow -D base
}

remove_hypr_dotfiles() {
    if [[ "$PLATFORM" == "Linux" ]]; then
        stow -D hyprland
    fi
}

if [[ $1 == "install-base" ]]; then
    install_base_dotfiles
if [[ $1 == "install-hypr" ]]; then
    install_hypr_dotfiles
elif [[ $1 == "uninstall-base" ]]; then
    remove_base_dotfiles
elif [[ $1 == "uninstall-hypr" ]]; then
    remove_hypr_dotfiles
else
    echo "usage: $0 install-base|install-hypr|uninstall-base|uninstall-hypr"
    exit 1
fi
