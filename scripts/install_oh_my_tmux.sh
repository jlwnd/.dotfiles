#!/usr/bin/env bash
# Idempotent installer for oh-my-tmux + TPM + local config
# Usage: ./scripts/install_oh_my_tmux.sh [--force]

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OH_MY_TMUX_DIR="$HOME/.tmux"
TPM_DIR="$HOME/.tmux/plugins/tpm"
LOCAL_CONF_SRC="$DOTFILES_DIR/.tmux.conf.local"
LOCAL_CONF_TARGET="$HOME/.tmux.conf.local"

FORCE=0
if [[ "${1:-}" == "--force" ]]; then
  FORCE=1
fi

echo "Installing Oh My Tmux (minimal)"

# Backup existing ~/.tmux if it exists and not a git clone of gpakosz/.tmux
if [[ -d "$OH_MY_TMUX_DIR" && $FORCE -eq 0 ]]; then
  echo "Found existing $OH_MY_TMUX_DIR" \
       "- skipping clone. Use --force to replace or remove the directory first." >&2
else
  if [[ -d "$OH_MY_TMUX_DIR" ]]; then
    echo "Removing existing $OH_MY_TMUX_DIR (force)"
    rm -rf "$OH_MY_TMUX_DIR"
  fi
  echo "Cloning gpakosz/.tmux"
  curl -fsSL "https://github.com/gpakosz/.tmux/raw/refs/heads/master/install.sh#$(date +%s)" | bash
fi

# Ensure TPM is installed (idempotent)
if [[ ! -d "$TPM_DIR" ]]; then
  echo "Installing TPM"
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "TPM already installed"
fi

# Link local conf (idempotent)
if [[ -e "$LOCAL_CONF_TARGET" && $FORCE -eq 0 ]]; then
  echo "$LOCAL_CONF_TARGET already exists - skipping (use --force to overwrite)"
else
  if [[ -e "$LOCAL_CONF_TARGET" ]]; then
    echo "Removing existing $LOCAL_CONF_TARGET"
    rm -f "$LOCAL_CONF_TARGET"
  fi
  echo "Linking $LOCAL_CONF_SRC -> $LOCAL_CONF_TARGET"
  ln -s "$LOCAL_CONF_SRC" "$LOCAL_CONF_TARGET"
fi

echo "Sourcing tmux config"
tmux source-file "$HOME/.tmux.conf" 2>/dev/null || true

echo "To finish: start tmux and press prefix+I to install plugins (TPM), or run ~/.tmux/plugins/tpm/bin/install_plugins"
echo "If you changed prefix, prefix is the default (C-b) in this setup." 
