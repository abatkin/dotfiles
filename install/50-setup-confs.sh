#!/bin/bash

CONFS_DIR=$DOTFILES_ROOT/confs
INSTALL_DOTFILE=$DOTFILES_SCRIPTS/install-dotfile.sh

mkdir -p $HOME/.config/kitty
$INSTALL_DOTFILE $CONFS_DIR kitty.conf .config/kitty/kitty.conf
$INSTALL_DOTFILE $CONFS_DIR starship.toml .config/starship.toml
mkdir -p $HOME/.config/rofi
$INSTALL_DOTFILE $CONFS_DIR config.rasi .config/rofi/config.rasi
mkdir -p $HOME/.config/mise
$INSTALL_DOTFILE $CONFS_DIR mise-config.toml .config/mise/config.toml

$INSTALL_DOTFILE $DOTFILES_ROOT nvim .config/nvim

if [[ ! -e $HOME/.config/launch-entries.ini ]]; then
  echo "Copying template for .config/launch-entries.ini"
  cp $CONFS_DIR/launch-entries.ini $HOME/.config/launch-entries.ini
fi




