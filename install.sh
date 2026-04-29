#!/bin/bash

# Exit on error, undefined vars, and pipe failures
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
REPO_URL="https://github.com/j-lewandowski/.dotfiles.git"

# --- UI Helpers ---
# ANSI color codes
RED='\03[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
NC='\033[0m' # No Color

info()    { echo -e " ${BLUE}[INFO]${NC} $1"; }
success() { echo -e " ${GREEN}[SUCCESS]${NC} $1"; }
warn()    { echo -e " ${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e " ${RED}[ERROR]${NC} $1"; exit 1; }
step()    { echo -e "\n${BOLD}==> $1${NC}"; }

# --- Requirements ---
step "Pre-flight checks"

if ! command -v curl >/dev/null 2>&1; then
    error "curl is required but not installed."
fi
if ! command -v git >/dev/null 2>&1; then
    error "git is required but not installed."
fi

# --- Clone or Update ---
step "Setting up .dotfiles repository"
if [ -d "$DOTFILES_DIR" ]; then
    info "Repository exists. Updating..."
    cd "$DOTFILES_DIR"
    git pull origin main
else
    info "Cloning repository..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
fi

# --- OS Detection & Dependencies ---
OS="$(uname -s)"
step "Installing dependencies for $OS"

if [ "$OS" = "Darwin" ]; then
    if ! command -v brew >/dev/null 2>&1; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Configure path for Apple Silicon/Intel
        eval "$(/opt/homebrew/bin/brew shellenv || /usr/local/bin/brew shellenv)"
    fi
    info "Running brew bundle/install..."
    brew install stow git curl neovim ripgrep fd npm python3
elif [ "$OS" = "Linux" ]; then
    info "Updating apt packages..."
    sudo apt-get update -y
    info "Installing basic packages..."
    sudo apt-get install -y stow git curl build-essential gcc make ripgrep fd-find npm python3-venv

    if ! command -v nvim >/dev/null 2>&1 || [[ ! $(nvim --version | head -n1) =~ "v0.9" ]] && [[ ! $(nvim --version | head -n1) =~ "v0.1" ]]; then
        info "Installing newest Neovim..."
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
        sudo rm -rf /opt/nvim
        sudo tar -C /opt -xzf nvim-linux64.tar.gz
        sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
        rm nvim-linux64.tar.gz
    else
        info "Neovim is already up to date."
    fi
else
    error "Unsupported OS: $OS"
fi

# --- Rust ---
step "Checking Rust installation"
if ! command -v cargo >/dev/null 2>&1; then
    info "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    info "Rust is already installed."
fi

# --- GNU Stow ---
step "Symlinking configurations"

# Backup existing files if they aren't symlinks
backup_if_exists() {
    local file="$1"
    if [ -f "$file" ] && [ ! -L "$file" ]; then
        warn "Backing up existing $file to ${file}.backup"
        mv "$file" "${file}.backup"
    elif [ -d "$file" ] && [ ! -L "$file" ]; then
        warn "Backing up existing directory $file to ${file}.backup"
        mv "$file" "${file}.backup"
    fi
}

info "Preparing destination for Neovim config..."
mkdir -p "$HOME/.config"
backup_if_exists "$HOME/.config/nvim"
backup_if_exists "$HOME/.gitconfig"

info "Applying Stow..."
# -R forces restowing (idempotent), --target specifies home
stow -R --target="$HOME" git
stow -R --target="$HOME" nvim

success "Dotfiles installation complete!"
info "Open Neovim with 'nvim' to initialize plugins."
