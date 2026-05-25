#!/bin/zsh

for _file in "$DOTFILES_ROOT/oh-my-zsh/"*; do
  install_dotfile "$DOTFILES_ROOT/oh-my-zsh" "$(basename $_file)" ".oh-my-zsh/custom/$(basename $_file)"
done

for _plugin in "$DOTFILES_ROOT/oh-my-zsh-plugins/"*; do
  install_dotfile "$DOTFILES_ROOT/oh-my-zsh-plugins" "$(basename $_plugin)" ".oh-my-zsh/custom/plugins/$(basename $_plugin)"
done

install_bundles "$DOTFILES_ROOT/zsh-bundles.txt" ~/.oh-my-zsh/custom/plugins ZSH
