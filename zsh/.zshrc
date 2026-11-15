# Show system info at the start of each interactive session (like CachyOS fish).
# Must run before the p10k instant prompt, which forbids console output after it.
if [[ -o interactive ]] && command -v fastfetch >/dev/null 2>&1; then
  fastfetch
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load?
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# --- syntax highlighting: mimic fish's default theme --------------------------
# Commands in the default colour, arguments cyan, strings yellow, unknown
# commands bright red, existing paths underlined. Must be set after the plugin loads.
typeset -gA ZSH_HIGHLIGHT_STYLES
for _k in command builtin alias suffix-alias global-alias function precommand \
          hashed-command reserved-word arg0; do
  ZSH_HIGHLIGHT_STYLES[$_k]='none'
done
unset _k
ZSH_HIGHLIGHT_STYLES[default]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=9'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=cyan,underline'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=cyan,underline'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=14'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=14'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=14'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=14'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=14'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=green'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[comment]='fg=red'
ZSH_HIGHLIGHT_STYLES[assign]='none'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- PATH ---------------------------------------------------------------------
# Prepend a directory to PATH only if it exists.
path_prepend() { [[ -d "$1" ]] && export PATH="$1:$PATH"; }

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.cargo/bin"
path_prepend "$HOME/.console-ninja/.bin"
path_prepend "$HOME/.opencode/bin"
path_prepend "$HOME/.antigravity/antigravity/bin"

# uv / other tools that ship an env script
[[ -r "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

# --- nvm ----------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# --- pyenv --------------------------------------------------------------------
export PYENV_ROOT="$HOME/.pyenv"
path_prepend "$PYENV_ROOT/bin"
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  if pyenv commands | grep -qx virtualenv-init; then
    eval "$(pyenv virtualenv-init -)"
  fi
fi

# --- completions --------------------------------------------------------------
[[ -d ~/.zsh/completions ]] && fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit && compinit

# Machine-specific settings (not tracked in the dotfiles repo)
[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local
