#!/bin/bash

install_dev_packages() {
    local packages=(
        clang
        cmake
        docker
        docker-compose
        dotnet-sdk
        gdb
        gcc
        git-lfs
        github-cli
        go
        lldb
        make
        mono
        ninja
        perf
        python
        python-pip
        ruby
        unityhub
        visual-studio-code-bin
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
