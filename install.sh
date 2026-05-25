#!/bin/bash

export DOTFILES_ROOT=$(cd "$(dirname "$0")" && pwd)

source "$DOTFILES_ROOT/install/lib.sh"

for _installer in "$DOTFILES_ROOT"/install/[0-9]*.sh; do
  echo "==> $(basename $_installer)"
  source "$_installer"
done
unset _installer
