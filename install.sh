#!/bin/bash

set -e

echo "🚀 Starting dotfiles installation..."

echo "📦 Installing basic packages (Stow, Git, Curl, compilers)..."
sudo apt update
sudo apt install -y stow git curl build-essential gcc make

echo "🔍 Installing Neovim dependencies (ripgrep, fd, npm)..."
sudo apt install -y ripgrep fd-find npm python3-venv

if ! command -v cargo &> /dev/null; then
    echo "🦀 Installing Rust and Cargo..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "✅ Rust is already installed."
fi

echo "🔗 Creating symlinks using GNU Stow..."
stow git
stow nvim

echo "🎉 Done! Open Neovim with 'nvim' to initialize plugins (Lazy.nvim will handle the rest)."