#!/bin/bash

mkdir -p ~/.config/kitty
install_dotfile "$DOTFILES_ROOT/confs" kitty.conf .config/kitty/kitty.conf

install_dotfile "$DOTFILES_ROOT/confs" starship.toml .config/starship.toml

mkdir -p ~/.config/rofi
install_dotfile "$DOTFILES_ROOT/confs" config.rasi .config/rofi/config.rasi

mkdir -p ~/.config/mise/conf.d
install_dotfile "$DOTFILES_ROOT/confs/mise" default-apps.toml .config/mise/conf.d/default-apps.toml
install_dotfile "$DOTFILES_ROOT/confs/mise" default-settings.toml .config/mise/conf.d/default-settings.toml

if [[ ! -e ~/.config/mise/config.toml ]]; then
  echo "Copying empty mise config.toml"
  cp "$DOTFILES_ROOT/confs/mise/empty-config.toml" ~/.config/mise/config.toml
fi

if [[ ! -e ~/.config/atuin/config.toml ]]; then
  mkdir -p ~/.config/atuin
  echo "Copying template atuin config to ~/.config/atuin/config.toml"
  cp "$DOTFILES_ROOT/confs/atuin.toml" ~/.config/atuin/config.toml
fi

if [[ ! -e ~/.config/launch-entries.ini ]]; then
  echo "Copying template for .config/launch-entries.ini"
  cp "$DOTFILES_ROOT/confs/launch-entries.ini" ~/.config/launch-entries.ini
fi
