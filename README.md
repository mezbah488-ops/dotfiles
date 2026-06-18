# Dotfiles

My personal dotfiles for a clean Ubuntu setup with a LaTeX workflow.

## What's Included

- **Zsh** — with Oh My Zsh, Powerlevel10k, autosuggestions, and syntax highlighting
- **Neovim** — custom config with LaTeX + inkscape-figures workflow
- **Alacritty** — terminal emulator config
- **Kitty** — terminal emulator config
- **Zathura** — PDF viewer config
- **JetBrains Mono Nerd Font** — for terminal and editor icons
- **Inkscape + inkscape-figures** — for figure management in LaTeX documents

## Installation

### Fresh installation on Ubuntu

```bash
# 1. Clone the dotfiles
git clone https://github.com/mezbah488-ops/dotfiles.git ~/dotfiles

# 2. Make the installer executable
chmod +x ~/dotfiles/install.sh

# 3. Run it
~/dotfiles/install.sh
```

### Existing System

If dotfiles are already cloned, just run:

```bash
chmod +x ~/dotfiles/install.sh
~/dotfiles/install.sh
```

It is safe to run on an existing system — every step checks if something is already installed and skips it if so.

## What the Installer Does

| Step | Description |
|------|-------------|
| 1 | Installs system packages via apt |
| 2 | Installs inkscape-figures via pip |
| 3 | Installs Oh My Zsh |
| 4 | Installs Powerlevel10k theme |
| 5 | Installs zsh-autosuggestions plugin |
| 6 | Installs zoxide |
| 7 | Installs JetBrains Mono Nerd Font |
| 8 | Symlinks all configs to their correct locations |
| 9 | Sets Zsh as the default shell |

## LaTeX Workflow

This setup includes an inkscape-figures workflow for managing figures in LaTeX documents via Neovim.

| Keybind | Action |
|---------|--------|
| `<leader>fi` | Create a new Inkscape figure (type name on a line first) |
| `<leader>fe` | Edit an existing figure |

Figures are stored in a `figures/` folder relative to your `.tex` file. The inkscape-figures watcher starts automatically whenever you open a `.tex` file in Neovim.

## Structure

```
dotfiles/
├── alacritty/       # Alacritty config
├── kitty/           # Kitty config
├── nvim/            # Neovim config
│   ├── init.lua
│   ├── ftplugin/
│   │   └── tex.lua  # LaTeX + inkscape-figures keybinds
│   └── lua/
├── .zshrc           # Zsh config
├── .p10k.zsh        # Powerlevel10k config
└── install.sh       # Setup script
```

## Requirements

- Ubuntu 22.04 or later

