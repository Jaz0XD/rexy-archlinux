#!/bin/bash

install_aur_packages() {
    local packages=(
        impala tuned hyprsunset tuned-ppd wiremix rofi-wayland bluetui hyprland xdg-desktop-portal-hyprland kitty awww-git hyprlock swaync
        waybar quickshell fastfetch zsh stow bc jq ffmpeg imagemagick yad hypridle
        notify-send thunar nwg-look steam neovim openrgb fzf lazygit sddm starship
        sddm-silent-theme zoxide ttf-jetbrains-mono-nerd gamemode lib32-gamemode
        ttf-ibm-plex ttf-roboto noto-fonts spotify spicetify-cli mangohud ttf-gohu-nerd sunset-cursors-git
        zen-browser-bin ttf-twemoji vesktop hyprshot obs-studio obs-vkcapture obs-pipewire-audio-capture swayosd yaru-icon-theme gtk-engine-murrine
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
