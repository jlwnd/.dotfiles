#!/bin/bash
set -euo pipefail
source "$HOME/.dotfiles/scripts/utils.sh"

LOCAL_CONFIG="$HOME/.gitconfig.local"

step "Configuring Git User"
if [ -f "$LOCAL_CONFIG" ]; then
    info "Local git configuration exists ($LOCAL_CONFIG). Skipping."
    exit 0
fi

# When installed via `curl ... | bash`, stdin is the script itself, so prompts
# must read from the terminal directly.
if ! { : < /dev/tty; } 2>/dev/null; then
    warn "No terminal available. Create $LOCAL_CONFIG manually:"
    warn "  git config --file $LOCAL_CONFIG user.name  \"Your Name\""
    warn "  git config --file $LOCAL_CONFIG user.email \"you@example.com\""
    exit 0
fi

info "No local git configuration found."
read -r -p "Enter your Git Name: " git_name < /dev/tty
read -r -p "Enter your Git Email: " git_email < /dev/tty

git config --file "$LOCAL_CONFIG" user.name "$git_name"
git config --file "$LOCAL_CONFIG" user.email "$git_email"

if command -v gh >/dev/null 2>&1; then
    info "GitHub CLI found, using it as credential helper for github.com."
    for host in https://github.com https://gist.github.com; do
        # The empty helper resets any helpers inherited from system config.
        git config --file "$LOCAL_CONFIG" --add "credential.$host.helper" ""
        git config --file "$LOCAL_CONFIG" --add "credential.$host.helper" "!gh auth git-credential"
    done
fi

success "Created $LOCAL_CONFIG"
