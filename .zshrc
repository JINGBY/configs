# Source of truth is in hg.nix

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

bindkey '^H' backward-kill-word
bindkey '\e[9;5u' autosuggest-accept # C-Tab

export BUN_INSTALL="$HOME/.bun"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# PATH
path=(
  $HOME/bin
  $HOME/.local/bin
  /usr/local/bin
  /opt/nvim-linux-x86_64/bin
  $BUN_INSTALL/bin
  $HOME/.platformio/penv/bin
  $HOME/.opencode/bin
  $path
)
