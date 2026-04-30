#!/usr/bin/env bash
# Stage: install pathogen, link vim/after, install vim bundles.
# Sourced by install.sh; must not call `exit`.

if [[ ! -e "$HOME/.vim/autoload/pathogen.vim" && "$LOCAL_ONLY" != "true" ]]; then
  log_info "Installing Pathogen"
  ensure_dir "$HOME/.vim/autoload"
  run curl -Sso "$HOME/.vim/autoload/pathogen.vim" \
    https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
  cat "$DOTFILES_ROOT/vim/notes.txt"
fi

link "$DOTFILES_ROOT/vim/after" "$HOME/.vim/after"

"$DOTFILES_SCRIPTS/install-bundles.sh" \
  "$DOTFILES_ROOT/vim/bundles.txt" \
  "$HOME/.vim/bundle" \
  VIM \
  "${BLACKLIST_VIM_MODULES:-}"
