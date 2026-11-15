#!/bin/bash
set -euo pipefail
source "$HOME/.dotfiles/scripts/utils.sh"

DOTFILES_DIR="$HOME/.dotfiles"
step "Running cleanup tasks (--clean flag provided)"

confirm() {
    # Reads from the terminal so it works with `curl ... | bash`.
    # Without a terminal, the answer is "no".
    local answer
    { : < /dev/tty; } 2>/dev/null || return 1
    read -r -p "$1 [y/N] " answer < /dev/tty
    [[ "$answer" =~ ^[Yy]$ ]]
}

info "Unstowing existing configurations..."
if command -v stow >/dev/null 2>&1; then
    for pkg in git nvim zsh tmux; do
        [ -d "$DOTFILES_DIR/$pkg" ] && (cd "$DOTFILES_DIR" && stow -D --target="$HOME" "$pkg" || true)
    done
fi

info "Removing Oh My Zsh and plugins..."
rm -rf "$HOME/.oh-my-zsh"

info "Removing Oh my tmux! and tmux plugins..."
rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}/tmux/oh-my-tmux"
rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins"
[ -L "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf" ] && rm -f "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"

info "Removing Neovim installations and state..."
rm -f "$HOME/.local/bin/nvim"
# Only remove the tarball install made by install_nvim_linux.sh, not a distro package.
if [ -L /usr/local/bin/nvim ] && [[ "$(readlink /usr/local/bin/nvim)" == /opt/nvim-linux-* ]]; then
    sudo rm -f /usr/local/bin/nvim
fi
sudo rm -rf /opt/nvim-linux-x86_64 /opt/nvim-linux-arm64 || true
rm -rf "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"

info "Removing Git configuration backups..."
rm -f "$HOME/.gitconfig" "$HOME/.gitconfig.backup"
rm -rf "$HOME/.config/nvim.backup"
if [ -f "$HOME/.gitconfig.local" ]; then
    if confirm "Also delete ~/.gitconfig.local (your name, email, credential helpers)?"; then
        rm -f "$HOME/.gitconfig.local"
        info "Removed ~/.gitconfig.local"
    else
        info "Keeping ~/.gitconfig.local"
    fi
fi

info "Removing path injections from shell profiles..."
[ -f "$HOME/.bashrc" ] && sed -i.bak '/export PATH="$HOME\/.local\/bin:$PATH"/d' "$HOME/.bashrc" && rm -f "$HOME/.bashrc.bak" || true

success "Cleanup complete."
