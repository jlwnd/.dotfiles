#!/bin/bash
set -euo pipefail
source "$HOME/.dotfiles/scripts/utils.sh"

step "Checking default shell"
if ! command -v zsh >/dev/null 2>&1; then
    warn "zsh is not installed. Skipping shell change."
    exit 0
fi

ZSH_PATH="$(command -v zsh)"
if [ "$SHELL" = "$ZSH_PATH" ] || [ "$SHELL" = "/bin/zsh" ]; then
    info "Default shell is already zsh."
    exit 0
fi

# When installed via `curl ... | bash`, stdin is the script itself, so chsh
# would read its password from the pipe. Use the terminal instead.
if ! { : < /dev/tty; } 2>/dev/null; then
    warn "No terminal available. Change shell manually: chsh -s $ZSH_PATH"
    exit 0
fi

info "Changing default shell to zsh..."
if chsh -s "$ZSH_PATH" < /dev/tty || { command -v sudo >/dev/null 2>&1 && sudo chsh -s "$ZSH_PATH" "$USER" < /dev/tty; }; then
    success "Shell changed. Log out and back in for changes to take effect."
else
    warn "Could not change default shell. Run manually: chsh -s $ZSH_PATH"
fi
