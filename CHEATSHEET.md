# 🧑‍💻 Dotfiles Cheatsheet

This is a quick reference guide for your custom Neovim keybindings, plugin configurations, and dotfiles commands.

## 🛠️ Dotfiles Commands

*   **Install:** `curl -fsSL https://raw.githubusercontent.com/jlwnd/.dotfiles/main/install.sh | bash`
*   **Clean Install:** `.../install.sh | bash -s -- --clean` (Removes old configs, plugins, and symlinks before installing)
*   **Update:** 
    ```bash
    cd ~/.dotfiles
    git pull origin main
    ./install.sh
    ```

---

## 📝 Neovim Keybindings

*Your `<leader>` key is mapped to `<Space>`.*

### 🚀 General & Movement
*   `<C-d>` / `<C-u>`: Jump half-page down/up and perfectly center the screen.
*   `n` / `N`: Go to next/previous search result and keep it centered.
*   `<leader>q`: Open the diagnostic Quickfix list.
*   `<C-j>` / `<C-k>`: Navigate through Quickfix list errors/warnings.
*   `<leader>j` / `<leader>k`: Navigate through Location list.
*   `<C-c>`: Equivalent to `<Esc>` in Insert mode.

### ✂️ Copy, Paste, & Editing
*   `J` (Visual mode): Move the selected block of code down one line (auto-indents!).
*   `K` (Visual mode): Move the selected block of code up one line (auto-indents!).
*   `J` (Normal mode): Append the line below to the current line, but keep the cursor exactly where it was.
*   `<C-c>` (Visual mode): Yank (copy) directly to the system clipboard.
*   `<C-S-v>` (Normal mode): Paste directly from the system clipboard.
*   `<leader>f`: Format the current file (using Conform).

### 📁 File Explorer (Neo-tree)
*   `<leader>e`: Toggle the Neo-tree file explorer sidebar.
*   `<leader>o`: Focus the Neo-tree sidebar (jump into it).

### 🔍 Search (Telescope)
*   `<leader>pf`: Find files in your current project.
*   `<C-p>`: Quick find git files.
*   `<leader>ps`: Grep/search for a specific word or string inside all files in your project.

### 🌳 Syntax & Code (Treesitter & LSP)
*   `<leader>vd`: Open floating diagnostic window for the current line.
*   `gd`: Go to Definition.
*   `K`: Show hover documentation.
*   `<leader>vws`: Workspace symbol search.
*   `<leader>vca`: Code action.
*   `<leader>vrr`: View references.
*   `<leader>vrn`: Rename symbol across project.
*   `<C-h>` (Insert mode): Show signature help.

### 📝 Comments
*   `gcc`: Toggle comment on the current line.
*   `gc` (Visual mode): Toggle comment on the selected block of code.

### 🐙 Git (Gitsigns)
*   `]c` / `[c`: Jump to the next/previous git hunk (change) in the file.
*   `<leader>hp`: Preview the git diff (hunk) under the cursor in a floating window.
*   `<leader>tb`: Toggle git blame for the current line (shows who wrote the line and when).
