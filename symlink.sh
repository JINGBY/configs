#!/usr/bin/env bash
set -euo pipefail

CONFIGS="${DOTFILES:-$HOME/configs}"

link() {
  rm -rf "$2"
  ln -sf "$1" "$2"
}

mkdir -p \
  ~/.config/tmux \
  ~/.config/nvim \
  ~/.config/ghostty \
  ~/.local/bin

link "$CONFIGS/nvim" ~/.config/nvim
link "$CONFIGS/ghostty" ~/.config/ghostty
link "$CONFIGS/tmux/tmux.conf" ~/.config/tmux/tmux.conf
link "$CONFIGS/tmux/tmux-sessionizer" ~/.local/bin/tmux-sessionizer
link "$CONFIGS/.zshrc" ~/.zshrc

chmod +x ~/.local/bin/tmux-sessionizer

echo "Symlinks done"
