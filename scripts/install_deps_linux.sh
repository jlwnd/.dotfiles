#!/bin/bash
set -euo pipefail
source "$HOME/.dotfiles/scripts/utils.sh"

step "Installing dependencies for Linux"

install_delta_deb() {
    if command -v delta >/dev/null 2>&1; then
        info "git-delta is already installed."
        return
    fi
    if apt-cache show git-delta >/dev/null 2>&1; then
        sudo apt-get install -y git-delta
        return
    fi
    info "Installing git-delta from GitHub releases..."
    local arch version tmp
    arch="$(dpkg --print-architecture)"
    version="$(curl -fsSL "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')"
    tmp="$(mktemp -d)"
    curl -fsSL -o "$tmp/delta.deb" "https://github.com/dandavison/delta/releases/download/${version}/git-delta_${version}_${arch}.deb"
    sudo dpkg -i "$tmp/delta.deb"
    rm -rf "$tmp"
}

if command -v pacman >/dev/null 2>&1; then
    info "Detected pacman (Arch-based)."
    sudo pacman -Syu --needed --noconfirm \
        stow git curl base-devel ripgrep fd npm python tmux zsh \
        git-delta neovim wl-clipboard xclip fontconfig
elif command -v apt-get >/dev/null 2>&1; then
    info "Detected apt (Debian/Ubuntu)."
    sudo apt-get update -y
    sudo apt-get install -y \
        stow git curl build-essential ripgrep fd-find npm python3-venv tmux zsh \
        wl-clipboard xclip fontconfig
    install_delta_deb
    # Debian/Ubuntu ship fd as `fdfind`; expose it as `fd`.
    if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
        info "Linked fdfind -> ~/.local/bin/fd"
    fi
elif command -v dnf >/dev/null 2>&1; then
    info "Detected dnf (Fedora)."
    sudo dnf install -y \
        stow git curl gcc make ripgrep fd-find npm python3 tmux zsh \
        git-delta neovim wl-clipboard xclip fontconfig
else
    error "Unsupported package manager (supported: pacman, apt, dnf)."
fi

success "Linux dependencies installed."
