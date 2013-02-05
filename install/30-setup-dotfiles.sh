#!/bin/sh

for FILE in $DOTFILES_ROOT/files/*; do
  BASENAME=$(basename $FILE)
  $DOTFILES_SCRIPTS/install-dotfile.sh $DOTFILES_ROOT/files $BASENAME .$BASENAME
done

