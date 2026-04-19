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
  ];
  # Neovim
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
  };
  home.file.".config/nvim".source = ./nvim;
  # Ghostty
  home.file.".config/ghostty".source = ./ghostty;
  # Tmux
  home.file.".config/tmux/tmux.conf".source = ./tmux/tmux.conf;
  home.file.".local/bin/tmux-sessionizer" = {
    source = ./tmux/tmux-sessionizer;
    executable = true;
  };
  # Zsh
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
      }
    ];
    initContent = ''
      bindkey '^H' backward-kill-word
      bindkey '\e[9;5u' autosuggest-accept
      export BUN_INSTALL="$HOME/.bun"
      [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    '';
    sessionVariables = {
      PATH = "$HOME/.nix-profile/bin:$HOME/bin:$HOME/.local/bin:/usr/local/bin:$HOME/.bun/bin:$HOME/.platformio/penv/bin:$HOME/.opencode/bin:$PATH";
    };
  };
  programs.home-manager.enable = true;
}
