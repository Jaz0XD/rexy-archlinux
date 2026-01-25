#!/bin/bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

# Load utilities
source "$BASE_DIR/utils/logging.sh"
source "$BASE_DIR/utils/checks.sh"

info "Welcome to the Rex OS Bootstrap Installer"

# Ensure not root
check_not_root

# Ensure internet
check_internet

# Ensure yay exists (install if needed)
check_yay

# -----------------------------------------------
# MACHINE TYPE SELECTION
# -----------------------------------------------
info "Select machine type:"
echo "1) Desktop"
echo "2) Laptop"
echo

read -rp "Enter choice (1/2): " MACHINE
echo

case "$MACHINE" in
    1)
        ok "Desktop selected."
        MACHINE_TYPE="desktop"
        ;;
    2)
        ok "Laptop selected."
        MACHINE_TYPE="laptop"
        ;;
    *)
        err "Invalid choice."
        exit 1
        ;;
esac

# Mode selection menu
echo
info "Select installation mode:"
echo "1) Minimal (fonts, basic tools, core requirements)"
echo "2) Normal  (Minimal + full system packages)"
echo "3) Developer (Normal + dev tools, SDKs, environments)"
echo

read -rp "Enter choice (1/2/3): " MODE
echo

case "$MODE" in
    1)
        ok "Minimal mode selected."
        INSTALL_MODE="minimal"
        ;;
    2)
        ok "Normal mode selected."
        INSTALL_MODE="normal"
        ;;
    3)
        ok "Developer mode selected."
        INSTALL_MODE="developer"
        ;;
    *)
        err "Invalid choice."
        exit 1
        ;;
esac

# Load modules
source "$BASE_DIR/modules/git.sh"
source "$BASE_DIR/modules/packages-core.sh"
source "$BASE_DIR/modules/packages-aur.sh"
source "$BASE_DIR/modules/packages-dev.sh"
source "$BASE_DIR/modules/zsh.sh"
source "$BASE_DIR/modules/stow.sh"
source "$BASE_DIR/modules/monitors.sh"
source "$BASE_DIR/modules/bin.sh"
source "$BASE_DIR/modules/ascii.sh"
source "$BASE_DIR/modules/reboot.sh"

# -----------------------------------------------
# GIT CONFIG
# -----------------------------------------------
info "Checking Git configuration…"
configure_git_if_needed

# -----------------------------------------------
# INSTALL PACKAGES
# -----------------------------------------------

info "Installing core packages..."
install_core_packages

if [[ "$INSTALL_MODE" != "minimal" ]]; then
    info "Installing AUR packages..."
    install_aur_packages
fi

if [[ "$INSTALL_MODE" == "developer" ]]; then
    info "Installing developer packages..."
    install_dev_packages
fi

ok "Package installation done!"

# -----------------------------------------------
# ZSH SETUP   👈 RIGHT HERE
# -----------------------------------------------
if [[ "$INSTALL_MODE" != "minimal" ]]; then
    info "Configuring Zsh..."
    setup_zsh
fi

# -----------------------------------------------
# DOTFILES (STOW)
# -----------------------------------------------
info "Applying dotfiles using stow..."
run_stow

# -----------------------------------------------
# HYPRLAND MONITOR CONFIG
# -----------------------------------------------
info "Generating Hyprland monitor configuration..."
generate_monitors_conf

# -----------------------------------------------
# LOCAL BIN
# -----------------------------------------------
info "Linking dotfiles executables..."
install_local_bin

# -----------------------------------------------
# ASCII ART FINISH
# -----------------------------------------------
print_rex_os_banner

# -----------------------------------------------
# REBOOT MENU
# -----------------------------------------------
reboot_prompt
