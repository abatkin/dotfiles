#!/usr/bin/env bash
# Stage: link files/* to ~/.<basename>.
# Sourced by install.sh; must not call `exit`.

for _file in "$DOTFILES_ROOT"/files/*; do
  link "$_file" "$HOME/.$(basename "$_file")"
done
unset _file
