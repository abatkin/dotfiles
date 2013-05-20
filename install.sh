#!/bin/sh

export DOTFILES_ROOT=$(cd $(dirname $0); pwd -P)
export DOTFILES_SCRIPTS=$DOTFILES_ROOT/scripts

for INSTALLER in $DOTFILES_ROOT/install/*.sh; do
  $INSTALLER
done

