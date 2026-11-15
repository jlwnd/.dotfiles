#!/bin/bash
# Fallback for distros whose packaged Neovim is too old (e.g. Debian/Ubuntu).
set -euo pipefail
source "$HOME/.dotfiles/scripts/utils.sh"

MIN_MAJOR=0
MIN_MINOR=10

step "Checking Neovim installation"
NEEDS_NVIM=true
if command -v nvim >/dev/null 2>&1; then
    # First line looks like: "NVIM v0.11.4"
    version="$(nvim --version | head -n1 | sed -E 's/^NVIM v([0-9]+)\.([0-9]+).*/\1 \2/')"
    read -r major minor <<< "$version"
    if [ "$major" -gt "$MIN_MAJOR" ] || { [ "$major" -eq "$MIN_MAJOR" ] && [ "$minor" -ge "$MIN_MINOR" ]; }; then
        NEEDS_NVIM=false
    fi
fi

if [ "$NEEDS_NVIM" = false ]; then
    info "Neovim is already up to date ($(nvim --version | head -n1))."
    exit 0
fi

case "$(uname -m)" in
    x86_64)        NVIM_PKG="nvim-linux-x86_64" ;;
    aarch64|arm64) NVIM_PKG="nvim-linux-arm64" ;;
    *) error "No prebuilt Neovim for architecture $(uname -m)." ;;
esac

info "Installing Neovim >= ${MIN_MAJOR}.${MIN_MINOR} via pre-compiled tarball ($NVIM_PKG)..."
tmp="$(mktemp -d)"
curl -fsSL -o "$tmp/nvim.tar.gz" "https://github.com/neovim/neovim/releases/latest/download/${NVIM_PKG}.tar.gz"
sudo rm -rf "/opt/${NVIM_PKG}"
sudo tar -C /opt -xzf "$tmp/nvim.tar.gz"
rm -rf "$tmp"
sudo ln -sf "/opt/${NVIM_PKG}/bin/nvim" /usr/local/bin/nvim
success "Neovim installed successfully."
