#!/bin/sh

mkdir -p ~/bin

for FILE in $DOTFILES_ROOT/binfiles/*; do
  BASENAME=$(basename $FILE)
  $DOTFILES_SCRIPTS/install-dotfile.sh $DOTFILES_ROOT/binfiles $BASENAME bin/$BASENAME
done

