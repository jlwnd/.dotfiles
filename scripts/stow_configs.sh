#!/bin/bash
set -euo pipefail
source "$HOME/.dotfiles/scripts/utils.sh"

step "Symlinking configurations"

backup_if_exists() {
    local file="$1"
    if [ -e "$file" ] && [ ! -L "$file" ]; then
        warn "Backing up $file to ${file}.backup"
        rm -rf "${file}.backup"
        mv "$file" "${file}.backup"
    fi
}

info "Preparing destinations..."
mkdir -p "$HOME/.config/tmux"
backup_if_exists "$HOME/.config/nvim"
backup_if_exists "$HOME/.config/tmux/tmux.conf.local"
backup_if_exists "$HOME/.gitconfig"
backup_if_exists "$HOME/.zshrc"
backup_if_exists "$HOME/.p10k.zsh"

info "Applying Stow..."
cd "$HOME/.dotfiles"
stow -R --target="$HOME" git
stow -R --target="$HOME" nvim
stow -R --target="$HOME" zsh
# --no-folding: ~/.config/tmux must stay a real directory, because Oh my tmux!
# puts its tmux.conf symlink and plugins there (they must not land in the repo).
stow -R --no-folding --target="$HOME" tmux
success "Configurations stowed successfully."
