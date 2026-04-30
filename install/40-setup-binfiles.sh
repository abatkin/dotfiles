#!/usr/bin/env bash
# Stage: link binfiles/* into ~/bin.
# Sourced by install.sh; must not call `exit`.

ensure_dir "$HOME/bin"

for _file in "$DOTFILES_ROOT"/binfiles/*; do
  link "$_file" "$HOME/bin/$(basename "$_file")"
done
unset _file
