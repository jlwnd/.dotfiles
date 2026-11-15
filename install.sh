#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
REPO_URL="https://github.com/jlwnd/.dotfiles.git"

if ! command -v curl >/dev/null 2>&1; then echo "[ERROR] curl required"; exit 1; fi
if ! command -v git >/dev/null 2>&1; then echo "[ERROR] git required"; exit 1; fi

if [ -d "$DOTFILES_DIR" ]; then
    cd "$DOTFILES_DIR"
    if ! git pull --ff-only origin main; then
        echo "[WARN] Could not update $DOTFILES_DIR (local changes or no network?). Continuing with the current version."
    fi
else
    git clone "$REPO_URL" "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
fi

source "$DOTFILES_DIR/scripts/utils.sh"

if [[ "${1:-}" == "--clean" ]]; then
    bash "$DOTFILES_DIR/scripts/cleanup.sh"
fi

bash "$DOTFILES_DIR/scripts/setup_git.sh"

OS="$(uname -s)"
if [ "$OS" = "Darwin" ]; then
    bash "$DOTFILES_DIR/scripts/install_deps_mac.sh"
elif [ "$OS" = "Linux" ]; then
    bash "$DOTFILES_DIR/scripts/install_deps_linux.sh"
    bash "$DOTFILES_DIR/scripts/install_nvim_linux.sh"
else
    error "Unsupported OS: $OS"
fi

bash "$DOTFILES_DIR/scripts/install_rust.sh"
bash "$DOTFILES_DIR/scripts/install_fonts.sh"
bash "$DOTFILES_DIR/scripts/install_zsh_env.sh"
bash "$DOTFILES_DIR/scripts/stow_configs.sh"
bash "$DOTFILES_DIR/scripts/setup_tmux.sh"
bash "$DOTFILES_DIR/scripts/setup_shell.sh"

success "Dotfiles installation complete!"
info "Open Neovim with 'nvim' to initialize plugins."
info "Start tmux to install its plugins automatically."
