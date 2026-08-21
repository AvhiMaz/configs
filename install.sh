#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

link() {
  local src="$DOTFILES/$1"
  local dst="$2"

  if [ ! -e "$src" ]; then
    echo "skip  $1 (missing)"
    return
  fi

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok    $dst"
    return
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$BACKUP/$(dirname "${dst#$HOME/}")"
    mv "$dst" "$BACKUP/${dst#$HOME/}"
    echo "moved $dst -> $BACKUP/${dst#$HOME/}"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "link  $dst"
}

link nvim "$HOME/.config/nvim"
if [ -L "$HOME/.tmux.conf" ]; then
  rm "$HOME/.tmux.conf"
  echo "rm    $HOME/.tmux.conf (legacy, shadows ~/.config/tmux)"
fi

link tmux "$HOME/.config/tmux"
link zsh/zshrc "$HOME/.zshrc"
link zsh/todo.sh "$HOME/.todo.sh"

case "$OS" in
  Darwin)
    link ghostty/config "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
    ;;
  Linux)
    link ghostty/config "$HOME/.config/ghostty/config"
    ;;
esac

echo
echo "done ($OS)"
[ -d "$BACKUP" ] && echo "backups in $BACKUP"
