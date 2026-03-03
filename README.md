# dotfiles

A personal collection of configuration files, scripts and themes to bootstrap and configure a development workstation.

**Overview**
- **Purpose:** Centralize configs and utilities for shell, editors, window manager, theming, and helper scripts.
- **Scope:** Alacritty, Hyprland/Sway configs, Waybar, theming tools, Neovim, zsh, helper scripts and modules.

**Quick install**
Run the provided installer or bootstrap scripts from the repository root. These scripts will symlink or apply your selected configs.

```bash
# Interactive bootstrap (recommended)
./bootstrap.sh

# Full install (non-interactive)
./install.sh
```

If you prefer selective installation, see the `modules/` folder for modular scripts (e.g. `modules/stow.sh`, `modules/packages-core.sh`).

**Key files**
- Installer / bootstrap: [install.sh](install.sh), [bootstrap.sh](bootstrap.sh)
- Module scripts: [modules/](modules/)
- Theme generator & tools: [zen0x/](zen0x/)
- Neovim config: [nvim/](nvim/)

**Customization**
- Edit the configs under the relevant folders (for example, `alacritty/alacritty.toml`, `hypr/`, `waybar/`) or create templates in `zen0x/templates`.
- Use the helper scripts in `bin/` and `modules/` to apply themes, set wallpapers, or install packages.

**Developer notes**
- Scripts expect a typical Linux environment. Some scripts call package managers or AUR helpers—review `modules/packages-*.sh` before running on a new system.
- Many files are intended to be managed with GNU Stow or symlinks; the repo includes `modules/stow.sh` to help.

**Contributing**
- Send PRs for improvements, new themes, or bug fixes. Keep changes focused and platform-agnostic where possible.

**License**
This repository is covered by the terms in [LICENSE.md](LICENSE.md).
