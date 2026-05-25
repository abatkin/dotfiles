#!/bin/bash

for _file in "$DOTFILES_ROOT/files/"*; do
  install_dotfile "$DOTFILES_ROOT/files" "$(basename $_file)" ".$(basename $_file)"
done
