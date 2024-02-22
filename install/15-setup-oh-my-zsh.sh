#!/bin/sh

for FILE in $DOTFILES_ROOT/oh-my-zsh/*; do
  BASENAME=$(basename $FILE)
  $DOTFILES_SCRIPTS/install-dotfile.sh $DOTFILES_ROOT/oh-my-zsh $BASENAME .oh-my-zsh/custom/$BASENAME
done

for PLUGIN in $DOTFILES_ROOT/oh-my-zsh-plugins/*; do
  BASENAME=$(basename $PLUGIN)
  $DOTFILES_SCRIPTS/install-dotfile.sh $DOTFILES_ROOT/oh-my-zsh-plugins $BASENAME .oh-my-zsh/custom/plugins/$BASENAME
done

$DOTFILES_SCRIPTS/install-bundles.sh $DOTFILES_ROOT/zsh-bundles.txt ~/.oh-my-zsh/custom/plugins ZSH


