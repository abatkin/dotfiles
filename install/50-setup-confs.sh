#!/bin/bash

CONFS_DIR=$DOTFILES_ROOT/confs
INSTALL_DOTFILE=$DOTFILES_SCRIPTS/install-dotfile.sh

mkdir -p $HOME/.config/kitty
$INSTALL_DOTFILE $CONFS_DIR kitty.conf .config/kitty/kitty.conf
$INSTALL_DOTFILE $CONFS_DIR starship.toml .config/starship.toml
mkdir -p $HOME/.config/rofi
$INSTALL_DOTFILE $CONFS_DIR config.rasi .config/rofi/config.rasi
mkdir -p $HOME/.config/mise/conf.d

$INSTALL_DOTFILE $CONFS_DIR/mise default-apps.toml .config/mise/conf.d/default-apps.toml
$INSTALL_DOTFILE $CONFS_DIR/mise default-settings.toml .config/mise/conf.d/default-settings.toml
if [[ ! -e $HOME/.config/mise/config.toml ]] ; then
  echo "Copying empty mise config.toml"
  cp $CONFS_DIR/mise/empty-config.toml $HOME/.config/mise/config.toml
fi

if [[ ! -e $HOME/.config/atuin/config.toml ]]; then
  mkdir -p $HOME/.config/atuin
  echo "Copying template atuin config to ~/.config/atuin/config.toml"
  cp $CONFS_DIR/atuin.toml $HOME/.config/atuin/config.toml
fi

if [[ ! -e $HOME/.config/launch-entries.ini ]]; then
  echo "Copying template for .config/launch-entries.ini"
  cp $CONFS_DIR/launch-entries.ini $HOME/.config/launch-entries.ini
fi




