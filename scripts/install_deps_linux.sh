#!/bin/bash
set -euo pipefail
source "$HOME/.dotfiles/scripts/utils.sh"

step "Installing dependencies for Linux"
info "Updating apt packages..."
sudo apt-get update -y
info "Installing basic packages..."
sudo apt-get install -y stow git curl build-essential gcc make ripgrep fd-find npm python3-venv tmux

if ! command -v delta >/dev/null 2>&1; then
    info "Installing git-delta..."
    DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
    curl -LO "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb"
    sudo dpkg -i "git-delta_${DELTA_VERSION}_amd64.deb"
    rm "git-delta_${DELTA_VERSION}_amd64.deb"
else
    info "git-delta is already installed."
fi
success "Linux dependencies installed."
