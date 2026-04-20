##!/usr/bin/env bash

CONFIGS=~/configs

link() {
  rm -rf "$2"
  ln -s "$1" "$2"
}

mkdir -p ~/.config/tmux
mkdir -p ~/.local/bin

link $CONFIGS/nvim ~/.config/nvim
link $CONFIGS/ghostty ~/.config/ghostty
link $CONFIGS/tmux/tmux.conf ~/.config/tmux/tmux.conf
link $CONFIGS/tmux/tmux-sessionizer ~/.local/bin/tmux-sessionizer
link $CONFIGS/.zshrc ~/.zshrc

chmod +x ~/.local/bin/tmux-sessionizer
