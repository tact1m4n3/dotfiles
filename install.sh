PLATFORM="$(uname)"

install_dotfiles() {
    mkdir -p ~/.config/alacritty

    ln -s ~/dotfiles/tmux ~/.config/tmux
    ln -s ~/dotfiles/nvim ~/.config/nvim

    if [[ "$PLATFORM" == "Linux" ]]; then
        ln -s ~/dotfiles/bash/linux/.bashrc ~/.bashrc
        ln -s ~/dotfiles/alacritty/linux/alacritty.toml ~/.config/alacritty/alacritty.toml
        ln -s ~/dotfiles/hypr/config ~/.config/hypr
        ln -s ~/dotfiles/waybar ~/.config/waybar
        ln -s ~/dotfiles/mako ~/.config/mako
        ln -s ~/dotfiles/tofi ~/.config/tofi
    elif [[ "$PLATFORM" == "Darwin" ]]; then
        ln -s ~/dotfiles/bash/macos/.bashrc ~/.bashrc
        ln -s ~/dotfiles/alacritty/macos/alacritty.toml ~/.config/alacritty/alacritty.toml
    fi
}

remove_dotfiles() {
    rm ~/.bashrc

    rm -r ~/.config/alacritty

    rm ~/.config/tmux
    rm ~/.config/nvim

    rm ~/.config/hypr
    rm ~/.config/waybar
    rm ~/.config/mako
    rm ~/.config/tofi
}

install_dotfiles
