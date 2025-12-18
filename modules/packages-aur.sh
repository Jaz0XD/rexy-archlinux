#!/bin/bash

install_aur_packages() {
    local packages=(
        mpvpaper teams-for-linux impala wiremix bluetui hyprland xdg-desktop-portal-hyprland kitty swww hyprlock swaync
        waybar rofi-wayland fastfetch zsh mpvpaper stow bc jq ffmpeg imagemagick yad
        notify-send nautilus nwg-look steam neovim openrgb fzf lazygit sddm starship
        sddm-silent-theme zoxide ttf-jetbrains-mono-nerd gamemode lib32-gamemode
        ttf-ibm-plex ttf-roboto noto-fonts mangohud ttf-gohu-nerd
        pokemon-colorscripts-git zen-browser-bin ttf-twemoji hyprshot xnviewmp
    )

    local to_install=()
    for pkg in "${packages[@]}"; do
        if pacman -Qi "$pkg" >/dev/null 2>&1; then
            info "$pkg already installed — skipping."
        else
            to_install+=("$pkg")
        fi
    done

    if (( ${#to_install[@]} > 0 )); then
        yay -S --noconfirm "${to_install[@]}"
    fi
}
