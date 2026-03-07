#!/bin/bash

install_core_packages() {

    local packages=(
        bat
        bluez
        bluez-utils
        btop
        brightnessctl
        cliphist
        curl
        dnsmasq
        edk2-ovmf
        fd
        gnome-keyring
        gvfs
        gvfs-mtp
        gzip
        kvantum
        lib32-vulkan-icd-loader
        libsecret
        networkmanager
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        noto-fonts-extra
        ntfs-3g
        openbsd-netcat
        openssh
        os-prober
        p7zip
        pavucontrol
        pipewire
        pipewire-pulse
        pipewire-alsa
        pipewire-jack
        playerctl
        qemu-full
        qt5-base
        qt5-wayland
        qt5ct
        qt6-base
        qt6-declarative
        qt6-wayland
        qt6-5compat
        qt6-multimedia
        qt6-shadertools
        qt6-svg
        qt6-quicktimeline
        qt6-wayland
        qt6ct
        ripgrep
        rsync
        sassc
        tar
        ufw
        unzip
        uwsm
        vde2
        virt-manager
        virt-viewer
        vulkan-icd-loader
        wireplumber
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
