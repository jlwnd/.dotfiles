#!/bin/bash
# Installs Oh my tmux! (https://github.com/gpakosz/.tmux) the manual way,
# using XDG paths. Our overrides live in tmux/.config/tmux/tmux.conf.local
# and are symlinked by stow_configs.sh. TPM and plugins are installed
# automatically by Oh my tmux! on first launch.
set -euo pipefail
source "$HOME/.dotfiles/scripts/utils.sh"

OH_MY_TMUX_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/oh-my-tmux"
TMUX_CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmux"

step "Setting up tmux (Oh my tmux!)"

if [ -d "$OH_MY_TMUX_DIR/.git" ]; then
    info "Updating Oh my tmux!..."
    git -C "$OH_MY_TMUX_DIR" pull --ff-only -q || warn "Could not update Oh my tmux!, keeping current version."
else
    info "Cloning Oh my tmux!..."
    mkdir -p "$(dirname "$OH_MY_TMUX_DIR")"
    git clone -q --single-branch https://github.com/gpakosz/.tmux.git "$OH_MY_TMUX_DIR"
fi

mkdir -p "$TMUX_CONF_DIR"
if [ -e "$TMUX_CONF_DIR/tmux.conf" ] && [ ! -L "$TMUX_CONF_DIR/tmux.conf" ]; then
    warn "Backing up $TMUX_CONF_DIR/tmux.conf to tmux.conf.backup"
    mv "$TMUX_CONF_DIR/tmux.conf" "$TMUX_CONF_DIR/tmux.conf.backup"
fi
ln -sfn "$OH_MY_TMUX_DIR/.tmux.conf" "$TMUX_CONF_DIR/tmux.conf"

# A legacy ~/.tmux.conf takes precedence over the XDG location.
if [ -e "$HOME/.tmux.conf" ] || [ -L "$HOME/.tmux.conf" ]; then
    warn "Moving legacy ~/.tmux.conf to ~/.tmux.conf.backup (it would shadow the XDG config)"
    mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup"
fi

success "tmux configured. Plugins will be installed on first tmux launch."
