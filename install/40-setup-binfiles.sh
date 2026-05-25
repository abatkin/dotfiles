#!/bin/zsh

mkdir -p ~/bin

for _file in "$DOTFILES_ROOT/binfiles/"*; do
  install_dotfile "$DOTFILES_ROOT/binfiles" "$(basename $_file)" "bin/$(basename $_file)"
done
