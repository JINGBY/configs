{ pkgs, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
in {
  home.username = "hannes";
  home.homeDirectory = if isLinux then "/home/hannes" else "/Users/hannes";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    git
    fzf
    ripgrep
    fd
    tree-sitter
    neovim
  ];
  home.file.".config/nvim".source = ./nvim;
  # Ghostty
  home.file.".config/ghostty".source = ./ghostty;
  # Tmux
  home.file.".config/tmux/tmux.conf".source = ./tmux/tmux.conf;
  home.file.".local/bin/tmux-sessionizer" = {
    source = ./tmux/tmux-sessionizer;
    executable = true;
  };
  home.file.".zshrc".source = ./.zshrc;
  programs.home-manager.enable = true;
}
