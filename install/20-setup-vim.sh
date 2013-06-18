#!/bin/zsh

if [[ ! -e ~/.vim/autoload/pathogen.vim ]]; then
  echo "Installing Pathogen"
  mkdir -p ~/.vim/autoload
  curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
  cat "$DOTFILES_ROOT/vim/notes.txt"
fi

$DOTFILES_SCRIPTS/install-dotfile.sh $DOTFILES_ROOT/vim after .vim/after

BUNDLE_DIR=~/.vim/bundle

for BUNDLE_URL in $(cat $DOTFILES_ROOT/vim/bundles.txt); do
  BUNDLE_NAME=$(echo "$BUNDLE_URL" | sed -e 's/.*\///' -e 's/\.git$//')
  if [[ ! -d $BUNDLE_DIR/$BUNDLE_NAME ]]; then
    echo "Adding bundle for $BUNDLE_NAME"
    git clone "$BUNDLE_URL" $BUNDLE_DIR/$BUNDLE_NAME
  fi
done


