#!/bin/bash
set -euo pipefail
source "$HOME/.dotfiles/scripts/utils.sh"

step "Checking default shell"
if [ "$SHELL" != "$(which zsh)" ] && [ "$SHELL" != "/bin/zsh" ]; then
    info "Changing default shell to zsh..."
    if command -v zsh >/dev/null 2>&1; then
        chsh -s "$(which zsh)"
        success "Shell changed. Log out and back in for changes to take effect."
    else
        warn "zsh is not installed. Skipping shell change."
    fi
else
    info "Default shell is already zsh."
fi
