#!/bin/bash
set -euo pipefail
source "$HOME/.dotfiles/scripts/utils.sh"

step "Checking Neovim installation"
NEEDS_NVIM=false
if ! command -v nvim >/dev/null 2>&1; then
    NEEDS_NVIM=true
else
    CURRENT_VERSION=$(nvim --version | head -n1)
    if [[ ! "$CURRENT_VERSION" =~ v0.(9|1) ]]; then
        NEEDS_NVIM=true
    fi
fi

if [ "$NEEDS_NVIM" = true ]; then
    info "Installing Neovim via pre-compiled tarball..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim-linux-x86_64
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    rm -f nvim-linux-x86_64.tar.gz
    sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
    success "Neovim installed successfully."
else
    info "Neovim is already up to date ($(nvim --version | head -n1))."
fi
