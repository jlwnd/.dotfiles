#!/usr/bin/env bash
# Cleanup installer for oh-my-tmux + TPM + local config
# Usage: ./scripts/uninstall_oh_my_tmux.sh [--keep-local]

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OH_MY_TMUX_DIR="$HOME/.tmux"
TPM_DIR="$HOME/.tmux/plugins/tpm"
LOCAL_CONF_TARGET="$HOME/.tmux.conf.local"

KEEP_LOCAL=0
if [[ "${1:-}" == "--keep-local" ]]; then
  KEEP_LOCAL=1
fi

echo "Uninstalling Oh My Tmux components"

if [[ -d "$TPM_DIR" ]]; then
  echo "Removing TPM: $TPM_DIR"
  rm -rf "$TPM_DIR"
else
  echo "TPM not found, skipping"
fi

if [[ -d "$OH_MY_TMUX_DIR" ]]; then
  echo "Removing $OH_MY_TMUX_DIR"
  rm -rf "$OH_MY_TMUX_DIR"
else
  echo "$OH_MY_TMUX_DIR not found, skipping"
fi

if [[ $KEEP_LOCAL -eq 0 && -L "$LOCAL_CONF_TARGET" ]]; then
  echo "Removing symlink $LOCAL_CONF_TARGET"
  rm -f "$LOCAL_CONF_TARGET"
elif [[ $KEEP_LOCAL -eq 0 && -e "$LOCAL_CONF_TARGET" ]]; then
  echo "$LOCAL_CONF_TARGET exists but is not a symlink; skipping removal (use --force to remove)"
fi

echo "Done. You may need to reload tmux or restart your terminal session."
