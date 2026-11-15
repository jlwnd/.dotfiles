# .dotfiles

My personal configuration files for **zsh**, **Neovim**, **tmux** and **Git**, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Supported: macOS (Homebrew) and Linux (Arch/pacman, Debian/Ubuntu/apt, Fedora/dnf).

## 🚀 Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/jlwnd/.dotfiles/main/install.sh | bash
```

For a fresh install that first removes the old configs and plugins:

```bash
curl -fsSL https://raw.githubusercontent.com/jlwnd/.dotfiles/main/install.sh | bash -s -- --clean
```

The script is safe to run more than once. It needs `curl`, `git` and `sudo` (for the package manager).

> ⚠️ As always with `curl | bash`: read [`install.sh`](install.sh) before you run it.

## 📦 What it does

1. Clones this repo to `~/.dotfiles`, or updates it if it is already there.
2. Asks for your Git name and email and writes them to `~/.gitconfig.local` (not tracked).
3. Installs packages: stow, ripgrep, fd, delta, tmux, zsh, Neovim, clipboard tools, …
4. Installs Rust (rustup), Meslo Nerd Fonts, Oh My Zsh, Powerlevel10k and the zsh plugins.
5. Symlinks the configs with Stow. Existing files are backed up as `*.backup`.
6. Installs [Oh my tmux!](https://github.com/gpakosz/.tmux). tmux plugins install on first launch.
7. Changes the default shell to zsh.

## 🗂️ Layout

| Package | Target |
|---|---|
| `git/`  | `~/.gitconfig` |
| `nvim/` | `~/.config/nvim/` |
| `zsh/`  | `~/.zshrc`, `~/.p10k.zsh` |
| `tmux/` | `~/.config/tmux/tmux.conf.local` |

Scripts live in `scripts/`. Keybindings are in [CHEATSHEET.md](CHEATSHEET.md).

## 🔒 Machine-specific settings

Files that are **not** tracked and are loaded automatically if present:

- `~/.gitconfig.local`: `user.name`, `user.email`, credential helpers.
  Use `git config --file ~/.gitconfig.local ...` instead of `git config --global`, because `~/.gitconfig` is a symlink into this repo.
- `~/.zshrc.local`: extra shell config, secrets, work-specific PATHs.

## 📄 License

[MIT](LICENSE)
