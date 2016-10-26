#!/bin/zsh

if [[ -e ~/.dotfiles-local ]]; then
  . ~/.dotfiles-local
fi

if [[ ! -e ~/.vim/autoload/pathogen.vim && ! "$LOCAL_ONLY" == "true" ]]; then
  echo "Installing Pathogen"
  mkdir -p ~/.vim/autoload
  curl -Sso ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
  cat "$DOTFILES_ROOT/vim/notes.txt"
fi

$DOTFILES_SCRIPTS/install-dotfile.sh $DOTFILES_ROOT/vim after .vim/after
$DOTFILES_SCRIPTS/install-bundles.sh $DOTFILES_ROOT/vim/bundles.txt ~/.vim/bundle VIM "$BLACKLIST_VIM_MODULES"

