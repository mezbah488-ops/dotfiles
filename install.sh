#!/bin/bash

set -e

echo "================================================"
echo "        Dotfiles Setup Script"
echo "================================================"

DOTFILES="$HOME/dotfiles"

# ── 1. System packages ────────────────────────────────────────────────────────
echo ""
echo "[1/10] Installing system packages..."
sudo apt update -y
sudo apt install -y \
    zsh \
    git \
    curl \
    wget \
    unzip \
    alacritty \
    kitty \
    zathura \
    neovim \
    latexmk \
    texlive-latex-extra \
    zsh-syntax-highlighting \
    eza \
    inkscape \
    python3-pip

# ── 2. inkscape-figures ───────────────────────────────────────────────────────
echo ""
echo "[2/10] Installing inkscape-figures..."
if ! command -v inkscape-figures &>/dev/null; then
    pip3 install inkscape-figures --break-system-packages
else
    echo "inkscape-figures already installed, skipping."
fi

# ── 3. Oh My Zsh ─────────────────────────────────────────────────────────────
echo ""
echo "[3/10] Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh already installed, skipping."
fi

# ── 4. Powerlevel10k ──────────────────────────────────────────────────────────
echo ""
echo "[4/10] Installing Powerlevel10k..."
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo "Powerlevel10k already installed, skipping."
fi

# ── 5. zsh-autosuggestions ────────────────────────────────────────────────────
echo ""
echo "[5/10] Installing zsh-autosuggestions..."
ZSH_AUTO="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
if [ ! -d "$ZSH_AUTO" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTO"
else
    echo "zsh-autosuggestions already installed, skipping."
fi

# ── 6. zoxide ─────────────────────────────────────────────────────────────────
echo ""
echo "[6/10] Installing zoxide..."
if ! command -v zoxide &>/dev/null; then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
    echo "zoxide already installed, skipping."
fi

# ── 7. JetBrains Mono Nerd Font ───────────────────────────────────────────────
echo ""
echo "[7/10] Installing JetBrains Mono Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
if ! fc-list | grep -qi "JetBrainsMono"; then
    cd "$FONT_DIR"
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip -o JetBrainsMono.zip
    rm JetBrainsMono.zip
    fc-cache -fv
    cd -
else
    echo "JetBrains Mono Nerd Font already installed, skipping."
fi

# ── 8. Symlink dotfiles ───────────────────────────────────────────────────────
echo ""
echo "[8/10] Symlinking dotfiles..."

# .zshrc
ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"
echo "Linked .zshrc"

# .p10k.zsh
ln -sf "$DOTFILES/.p10k.zsh" "$HOME/.p10k.zsh"
echo "Linked .p10k.zsh"

# Alacritty
rm -rf "$HOME/.config/alacritty"
ln -sf "$DOTFILES/alacritty" "$HOME/.config/alacritty"
echo "Linked alacritty config"

# Neovim
rm -rf "$HOME/.config/nvim"
ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
echo "Linked nvim config"

# Kitty
if [ -d "$DOTFILES/kitty" ]; then
    rm -rf "$HOME/.config/kitty"
    ln -sf "$DOTFILES/kitty" "$HOME/.config/kitty"
    echo "Linked kitty config"
fi

# Zathura
if [ -d "$DOTFILES/zathura" ]; then
    rm -rf "$HOME/.config/zathura"
    ln -sf "$DOTFILES/zathura" "$HOME/.config/zathura"
    echo "Linked zathura config"
fi

# ── 9. Set Zsh as default shell ───────────────────────────────────────────────
echo ""
echo "[9/10] Setting Zsh as default shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
    echo "Default shell set to Zsh. Please log out and back in."
else
    echo "Zsh is already the default shell."
fi

# ── 10. Done ──────────────────────────────────────────────────────────────────
echo ""
echo "================================================"
echo "  Setup complete! Please log out and back in."
echo "================================================"
