#!/usr/bin/env bash
set -euo pipefail

CONFIGS="${DOTFILES:-$HOME/configs}"
MAC=false

for arg in "$@"; do
  case $arg in
    --mac) MAC=true ;;
  esac
done
link() {
  rm -rf "$2"
  ln -sf "$1" "$2"
}

mkdir -p \
  ~/.config/ghostty \
  ~/.config/tmux \
  ~/.local/bin
  ~/.config/nvim \

link "$CONFIGS/ghostty" ~/.config/ghostty
link "$CONFIGS/.zshrc" ~/.zshrc
link "$CONFIGS/tmux/tmux.conf" ~/.config/tmux/tmux.conf
link "$CONFIGS/tmux/tmux-sessionizer" ~/.local/bin/tmux-sessionizer
link "$CONFIGS/nvim" ~/.config/nvim

chmod +x ~/.local/bin/tmux-sessionizer

if $MAC; then
  mkdir -p ~/.config/karabiner ~/.config/aerospace
  link "$CONFIGS/karabiner" ~/.config/karabiner
  link "$CONFIGS/aerospace"  ~/.config/aerospace
fi


echo "Symlinks done"
