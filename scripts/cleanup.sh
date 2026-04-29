#!/bin/bash
set -euo pipefail
source "$HOME/.dotfiles/scripts/utils.sh"

DOTFILES_DIR="$HOME/.dotfiles"
step "Running cleanup tasks (--clean flag provided)"

info "Unstowing existing configurations..."
if command -v stow >/dev/null 2>&1; then
    [ -d "$DOTFILES_DIR/git" ] && (cd "$DOTFILES_DIR" && stow -D --target="$HOME" git || true)
    [ -d "$DOTFILES_DIR/nvim" ] && (cd "$DOTFILES_DIR" && stow -D --target="$HOME" nvim || true)
fi

info "Removing Neovim installations and state..."
rm -f "$HOME/.local/bin/nvim"
sudo rm -rf /opt/nvim-linux-x86_64 || true
sudo rm -f /usr/local/bin/nvim || true
rm -rf "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"

info "Removing Git configuration and backups..."
rm -f "$HOME/.gitconfig" "$HOME/.gitconfig.local" "$HOME/.gitconfig.backup"
rm -rf "$HOME/.config/nvim.backup"

info "Removing path injections from shell profiles..."
[ -f "$HOME/.zshrc" ] && sed -i.bak '/export PATH="$HOME\/.local\/bin:$PATH"/d' "$HOME/.zshrc" && rm -f "$HOME/.zshrc.bak" || true
[ -f "$HOME/.bashrc" ] && sed -i.bak '/export PATH="$HOME\/.local\/bin:$PATH"/d' "$HOME/.bashrc" && rm -f "$HOME/.bashrc.bak" || true

success "Cleanup complete."
