#!/bin/zsh

export DOTFILES_ROOT=${0:A:h}

source "$DOTFILES_ROOT/install/lib.sh"

for _installer in "$DOTFILES_ROOT"/install/[0-9]*.sh; do
  echo "==> $(basename $_installer)"
  source "$_installer"
done
unset _installer
