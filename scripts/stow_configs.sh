#!/bin/bash
set -euo pipefail
source "$HOME/.dotfiles/scripts/utils.sh"

step "Symlinking configurations"

backup_if_exists() {
    local file="$1"
    if [ -f "$file" ] && [ ! -L "$file" ]; then
        warn "Backing up $file to ${file}.backup"
        mv "$file" "${file}.backup"
    elif [ -d "$file" ] && [ ! -L "$file" ]; then
        warn "Backing up directory $file to ${file}.backup"
        mv "$file" "${file}.backup"
    fi
}

info "Preparing destination for Neovim config..."
mkdir -p "$HOME/.config"
backup_if_exists "$HOME/.config/nvim"
backup_if_exists "$HOME/.gitconfig"

info "Applying Stow..."
cd "$HOME/.dotfiles"
stow -R --target="$HOME" git
stow -R --target="$HOME" nvim
success "Configurations stowed successfully."
