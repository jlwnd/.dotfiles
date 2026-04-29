#!/bin/bash
set -euo pipefail
source "$HOME/.dotfiles/scripts/utils.sh"

step "Installing Meslo Nerd Fonts"
OS="$(uname -s)"
FONT_DIR=""

if [ "$OS" = "Darwin" ]; then
    FONT_DIR="$HOME/Library/Fonts"
elif [ "$OS" = "Linux" ]; then
    FONT_DIR="$HOME/.local/share/fonts"
fi

if [ -n "$FONT_DIR" ]; then
    mkdir -p "$FONT_DIR"
    if ! ls "$FONT_DIR"/MesloLGS\ NF*.ttf >/dev/null 2>&1; then
        info "Downloading fonts..."
        curl -fLo "$FONT_DIR/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
        curl -fLo "$FONT_DIR/MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
        curl -fLo "$FONT_DIR/MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
        curl -fLo "$FONT_DIR/MesloLGS NF Bold Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
        
        if [ "$OS" = "Linux" ]; then
            info "Updating font cache..."
            fc-cache -f -v >/dev/null 2>&1 || warn "Could not update font cache, skipping."
        fi
        success "Fonts installed."
    else
        info "Meslo Nerd Fonts are already installed."
    fi
fi
