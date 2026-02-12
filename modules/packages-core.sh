#!/bin/bash

install_core_packages() {

    local packages=(
        bat
        bleachbit
        bluez
        bluez-utils
        btop
        brightnessctl
        cliphist
        curl
        duf
        dust
        efibootmgr
        fd
        gnome-keyring
        gvfs
        gvfs-mtp
        gzip
        lib32-vulkan-icd-loader
        libsecret
        lxappearance
        ncdu
        network-manager-applet
        networkmanager
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        noto-fonts-extra
        ntfs-3g
        openssh
        os-prober
        p7zip
        pavucontrol
        playerctl
        qt5-base
        qt5-wayland
        qt5ct
        qt6-base
        qt6-wayland
        ripgrep
        rsync
        sassc
        tar
        ufw
        unzip
        uwsm
        vulkan-icd-loader
        wget
        wl-clipboard
        zip
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
