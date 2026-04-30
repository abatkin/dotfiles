#!/usr/bin/env bash
# Stage: install oh-my-zsh customizations and plugins.
# Sourced by install.sh; must not call `exit`.

for _file in "$DOTFILES_ROOT"/oh-my-zsh/*; do
  link "$_file" "$HOME/.oh-my-zsh/custom/$(basename "$_file")"
done
unset _file

for _plugin in "$DOTFILES_ROOT"/oh-my-zsh-plugins/*; do
  link "$_plugin" "$HOME/.oh-my-zsh/custom/plugins/$(basename "$_plugin")"
done
unset _plugin

"$DOTFILES_SCRIPTS/install-bundles.sh" \
  "$DOTFILES_ROOT/zsh-bundles.txt" \
  "$HOME/.oh-my-zsh/custom/plugins" \
  ZSH
