#!/bin/sh

CONFS_DIR=$DOTFILES_ROOT/confs
INSTALL_DOTFILE=$DOTFILES_SCRIPTS/install-dotfile.sh

mkdir -p $HOME/.config/kitty
$INSTALL_DOTFILE $CONFS_DIR kitty.conf .config/kitty/kitty.conf



