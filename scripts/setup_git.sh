#!/bin/bash
set -euo pipefail
source "$HOME/.dotfiles/scripts/utils.sh"

step "Configuring Git User"
if [ ! -f "$HOME/.gitconfig.local" ]; then
    info "No local git configuration found."
    read -p "Enter your Git Name: " git_name
    read -p "Enter your Git Email: " git_email
    
    cat <<IN_EOF > "$HOME/.gitconfig.local"
[user]
	name = $git_name
	email = $git_email
IN_EOF
    success "Created ~/.gitconfig.local"
else
    info "Local git configuration exists. Skipping."
fi
