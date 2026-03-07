#!/bin/bash

install_aur_packages() {
    local packages=(
        abyssal-gtk-theme
        alacritty
        ani-cli
        awww-git
        bc
        blender
        bluetui
        brave-bin
        bridge-utils
        cpupower
        elephant
        elephant-desktopapplications
        elephant-providerlist
        ffmpeg
        fastfetch
        fzf
        gamemode
        github-copilot-cli
        gpu-screen-recorder
        gtk-engine-murrine
        heroic-games-launcher
        hyprland
        hyprpolkitagent
        hyprshot
        hyprsunset
        impala
        imagemagick
        irqbalance
        jq
        lazygit
        lib32-gamemode
        localsend
        ly
        mako
        mangohud
        mangojuice
        nautilus
        neovim
        notify-send
        noto-fonts
        nwg-look
        obs-pipewire-audio-capture
        obs-studio
        obs-vkcapture
	      oh-my-posh
        openrgb
        preload
        satty
        scx-scheds
        spicetify-cli
        spotify
        starship
        steam
        stow
        sunset-cursors-git
        swayosd
        tlauncher-installer
        tor-browser-bin
        ttf-gohu-nerd
        ttf-ibm-plex
        ttf-jetbrains-mono-nerd
        ttf-roboto
        ttf-twemoji
        tuned
        tuned-ppd
        vesktop
        walker
        waybar
        wine
        winetricks
        wiremix
        wlogout
        xdg-desktop-portal-hyprland
        yad
        yaru-icon-theme
        yazi
        zram-generator
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
