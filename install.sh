#!/bin/sh

export DOTFILES_ROOT=$(realpath $(dirname $0))
export DOTFILES_SCRIPTS=$DOTFILES_ROOT/scripts

for INSTALLER in $DOTFILES_ROOT/install/*.sh; do
  $INSTALLER
done

