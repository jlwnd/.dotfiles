#!/bin/bash
set -euo pipefail
source "$HOME/.dotfiles/scripts/utils.sh"

step "Installing dependencies for macOS"
if ! command -v brew >/dev/null 2>&1; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv || /usr/local/bin/brew shellenv)"
fi

info "Running brew install..."
brew install stow git curl neovim ripgrep fd npm python3 git-delta tmux
success "macOS dependencies installed."
