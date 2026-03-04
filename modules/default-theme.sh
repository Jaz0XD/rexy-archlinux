apply_default_theme() {
    local THEMES="$HOME/.config/themes/colorschemes"
    local WAYBAR_THEMES="$HOME/.config/themes/waybar"
    local CURRENT="$THEMES/current"
    local DEFAULT_THEME="Abyssal"
    local DEFAULT_WAYBAR_THEME="Default"

    if [[ -d "$THEMES/$DEFAULT_THEME" ]]; then
        info "Applying default theme: $DEFAULT_THEME"
        info "Applying default waybar theme: $DEFAULT_WAYBAR_THEME"

        ln -sfn "$THEMES/$DEFAULT_THEME" "$CURRENT"

        zen0x-theme-generate "$DEFAULT_THEME"

        zen0x-apply-generated-theme
        zen0x-theme-gtk
        zen0x-theme-set-vscode
        zen0x-theme-wallpaper "$DEFAULT_THEME"
        zen0x-theme-reload

        ok "Default theme applied."
    else
        warn "Default theme '$DEFAULT_THEME' not found. Skipping theme setup."
        warn "Default waybar theme '$DEFAULT_WAYBAR_THEME' not found. Skipping waybar theme setup."
    fi
    local DOTFILES_DIR
    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

    mkdir -p "$THEMES"

    # If the theme isn't installed in the user's config, try linking it from the repo
    if [[ ! -d "$THEMES/$DEFAULT_THEME" ]]; then
        if [[ -d "$DOTFILES_DIR/themes/colorschemes/$DEFAULT_THEME" ]]; then
            ln -sfn "$DOTFILES_DIR/themes/colorschemes/$DEFAULT_THEME" "$THEMES/$DEFAULT_THEME"
            info "Linked $DEFAULT_THEME from repo to $THEMES"
        elif [[ -d "$DOTFILES_DIR/themes/$DEFAULT_THEME" ]]; then
            ln -sfn "$DOTFILES_DIR/themes/$DEFAULT_THEME" "$THEMES/$DEFAULT_THEME"
            info "Linked $DEFAULT_THEME from repo to $THEMES"
        fi
    fi

    # Ensure waybar themes dir exists and link fallback if necessary
    if [[ ! -d "$WAYBAR_THEMES/$DEFAULT_WAYBAR_THEME" ]]; then
        if [[ -d "$DOTFILES_DIR/themes/waybar/$DEFAULT_WAYBAR_THEME" ]]; then
            mkdir -p "$WAYBAR_THEMES"
            ln -sfn "$DOTFILES_DIR/themes/waybar/$DEFAULT_WAYBAR_THEME" "$WAYBAR_THEMES/$DEFAULT_WAYBAR_THEME"
            info "Linked waybar theme $DEFAULT_WAYBAR_THEME from repo to $WAYBAR_THEMES"
        fi
    fi
}
