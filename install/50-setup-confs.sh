#!/usr/bin/env bash
# Stage: install ~/.config entries (kitty, starship, rofi, mise, atuin, nvim).
# Sourced by install.sh; must not call `exit`.

_CONFS="$DOTFILES_ROOT/confs"

link "$_CONFS/kitty.conf"    "$HOME/.config/kitty/kitty.conf"
link "$_CONFS/starship.toml" "$HOME/.config/starship.toml"
link "$_CONFS/config.rasi"   "$HOME/.config/rofi/config.rasi"

link "$_CONFS/mise/default-apps.toml"     "$HOME/.config/mise/conf.d/default-apps.toml"
link "$_CONFS/mise/default-settings.toml" "$HOME/.config/mise/conf.d/default-settings.toml"
copy_template "$_CONFS/mise/empty-config.toml" "$HOME/.config/mise/config.toml"

copy_template "$_CONFS/atuin.toml"          "$HOME/.config/atuin/config.toml"
copy_template "$_CONFS/launch-entries.ini"  "$HOME/.config/launch-entries.ini"

link "$DOTFILES_ROOT/nvim" "$HOME/.config/nvim"

unset _CONFS
