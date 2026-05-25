#!/bin/bash

[[ -e ~/.dotfiles-local ]] && source ~/.dotfiles-local

if [[ ! -e ~/.vim/autoload/pathogen.vim && "$LOCAL_ONLY" != "true" ]]; then
  echo "Installing Pathogen"
  run mkdir -p ~/.vim/autoload
  run curl -Sso ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
  cat "$DOTFILES_ROOT/vim/notes.txt"
fi

install_dotfile "$DOTFILES_ROOT/vim" after .vim/after
install_bundles "$DOTFILES_ROOT/vim/bundles.txt" ~/.vim/bundle VIM "${BLACKLIST_VIM_MODULES:-}"
