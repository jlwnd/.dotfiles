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

# --- Git Setup ---
step "Configuring Git User"
if [ ! -f "$HOME/.gitconfig.local" ]; then
    info "No local git configuration found. Let's set it up."
    read -p "Enter your Git Name (e.g., Jane Doe): " git_name
    read -p "Enter your Git Email (e.g., jane@example.com): " git_email
    
    cat <<EOF > "$HOME/.gitconfig.local"
[user]
	name = $git_name
	email = $git_email
EOF
    success "Created ~/.gitconfig.local"
else
    info "Local git configuration (~/.gitconfig.local) already exists. Skipping."
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
    brew install stow git curl neovim ripgrep fd npm python3 git-delta
elif [ "$OS" = "Linux" ]; then
    info "Updating apt packages..."
    sudo apt-get update -y
    info "Installing basic packages..."
    sudo apt-get install -y stow git curl build-essential gcc make ripgrep fd-find npm python3-venv

    # Check if Neovim is missing or outdated
    NEEDS_NVIM=false
    if ! command -v nvim >/dev/null 2>&1; then
        NEEDS_NVIM=true
    else
        CURRENT_VERSION=$(nvim --version | head -n1)
        if [[ ! "$CURRENT_VERSION" =~ v0.(9|1) ]]; then
            NEEDS_NVIM=true
        fi
    fi

    if [ "$NEEDS_NVIM" = true ]; then
        info "Installing/Updating Neovim..."
        info "Installing/Updating Neovim via AppImage..."
        mkdir -p "$HOME/.local/bin"
        
        # Download the AppImage
        URL="https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
        if curl -fLo "$HOME/.local/bin/nvim" "$URL"; then
            chmod u+x "$HOME/.local/bin/nvim"
            
            # Ensure ~/.local/bin is in PATH for the current session
            export PATH="$HOME/.local/bin:$PATH"
            
            # Add to shell profile if not already there
            if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.zshrc" 2>/dev/null; then
                echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
            fi
            if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc" 2>/dev/null; then
                echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
            fi
            
            success "Neovim installed successfully."
        else
            error "Failed to download Neovim from $URL"
        fi
    else
        info "Neovim is already up to date ($(nvim --version | head -n1))."
    fi

    if ! command -v delta >/dev/null 2>&1; then
        info "Installing git-delta..."
        DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
        curl -LO "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb"
        sudo dpkg -i "git-delta_${DELTA_VERSION}_amd64.deb"
        rm "git-delta_${DELTA_VERSION}_amd64.deb"
    else
        info "git-delta is already installed."
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

# --- Fonts ---
step "Installing Meslo Nerd Fonts"
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

# --- Shell ---
step "Checking default shell"
if [ "$SHELL" != "$(which zsh)" ] && [ "$SHELL" != "/bin/zsh" ]; then
    info "Changing default shell to zsh..."
    if command -v zsh >/dev/null 2>&1; then
        chsh -s "$(which zsh)"
        success "Shell changed. Please log out and back in for changes to take effect."
    else
        warn "zsh is not installed. Skipping shell change."
    fi
else
    info "Default shell is already zsh."
fi

success "Dotfiles installation complete!"
info "Open Neovim with 'nvim' to initialize plugins."
