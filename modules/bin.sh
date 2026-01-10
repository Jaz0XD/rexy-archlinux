#!/usr/bin/env bash
set -euo pipefail

install_local_bin() {
    local DOTFILES_DIR="$BASE_DIR"
    local SRC_DIR="$DOTFILES_DIR/bin"
    local DST_DIR="$HOME/.local/bin"

    info "Installing executables to ~/.local/bin"

    if [[ ! -d "$SRC_DIR" ]]; then
        warn "No bin/ directory found in dotfiles, skipping."
        return 0
    fi

    mkdir -p "$DST_DIR"

    local linked=0
    local skipped=0

    for file in "$SRC_DIR"/*; do
        [[ -f "$file" ]] || continue

        if [[ ! -x "$file" ]]; then
            debug "Skipping $(basename "$file") (not executable)"
            ((skipped++))
            continue
        fi

        local name
        name="$(basename "$file")"
        local target="$DST_DIR/$name"

        if [[ -e "$target" ]]; then
            warn "Executable already exists: $name (skipping)"
            ((skipped++))
            continue
        fi

        ln -s "$file" "$target"
        ok "Linked $name"
        ((linked++))
    done

    ok "Local bin setup complete ($linked linked, $skipped skipped)"
}
