#!/bin/bash

run_stow() {
    local CONFIG_DIR="$HOME/.config"
    mkdir -p "$CONFIG_DIR"

    local folders=(hypr waybar kitty fastfetch rofi gtk-3.0 gtk-4.0 swaync swayosd wlogout)

    for folder in "${folders[@]}"; do
        local target="$CONFIG_DIR/$folder"
        mkdir -p "$target"

        info "📦 Stowing $folder..."

        stow --target="$target" "$folder"

        ok "$folder stowed successfully."
    done

    info "🚀 Stowing starship..."
    stow --target="$CONFIG_DIR" starship
    ok "starship stowed successfully."

    info "🚀 Stowing starship..."
    mkdir -p "$HOME/Pictures"
    stow --target="$HOME/Pictures" Pictures
    ok "starship stowed successfully."
}
