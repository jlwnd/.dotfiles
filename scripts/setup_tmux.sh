if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    info "Installing Tmux Plugin Manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
