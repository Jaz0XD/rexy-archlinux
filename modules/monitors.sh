#!/bin/bash

generate_monitors_conf() {
    local HYPR_CONF_DIR="$HOME/.config/hypr/configs"
    local TEMPLATE="$BASE_DIR/hypr/configs/monitors.conf.template"
    local TARGET="$HYPR_CONF_DIR/monitors.conf"

    mkdir -p "$HYPR_CONF_DIR"

    if [[ "$MACHINE_TYPE" == "desktop" ]]; then
        MONITOR_LINE="monitor=DP-1,1920x1080@300,0x0,1"
    else
        MONITOR_LINE="monitor=eDP-1,1920x1080@144,0x0,1"
    fi

    sed "s|{{MONITOR_LINE}}|$MONITOR_LINE|" "$TEMPLATE" > "$TARGET"

    ok "Hyprland monitor configuration generated for $MACHINE_TYPE"

    # Reload Hyprland config if running
    if command -v hyprctl >/dev/null 2>&1 && hyprctl monitors >/dev/null 2>&1; then
        info "Reloading Hyprland configuration..."
        hyprctl reload
        ok "Hyprland configuration reloaded"
    else
        warn "Hyprland not running, reload skipped"
    fi
}
