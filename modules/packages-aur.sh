#!/bin/bash

install_aur_packages() {
    local packages=(
        abyssal-gtk-theme
        ani-cli
        awww-git
        bc
        bluetui
        cpupower
        discord
        ffmpeg
        fastfetch
        fzf
        gamemode
        gtk-engine-murrine
        hyprland
        hypridle
        hyprlock
        hyprshot
        hyprsunset
        idescriptor-git
        impala
        imagemagick
        irqbalance
        jq
        kitty
        lazygit
        lib32-gamemode
        localsend
        mangohud
        nautilus
        neovim
        notify-send
        noto-fonts
        nwg-look
        obs-pipewire-audio-capture
        obs-studio
        obs-vkcapture
        openrgb
        preload
        quickshell
        rofi-wayland
        scx-scheds
        sddm
        sddm-silent-theme
        spicetify-cli
        spotify
        starship
        steam
        stow
        sunset-cursors-git
        swaync
        swayosd
        treesitter-cli
        ttf-gohu-nerd
        ttf-ibm-plex
        ttf-jetbrains-mono-nerd
        ttf-roboto
        ttf-twemoji
        tuned
        tuned-ppd
        waybar
        wiremix
        wlogout
        xdg-desktop-portal-hyprland
        yad
        zram-generator
        zen-browser-bin
        zoxide
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
