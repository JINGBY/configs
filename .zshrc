export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

bindkey '^H' backward-kill-word

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
