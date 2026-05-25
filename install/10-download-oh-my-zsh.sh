#!/bin/zsh

echo "Checking out oh-my-zsh"
if [[ "$LOCAL_ONLY" != "true" ]]; then
  if [[ ! -d ~/.oh-my-zsh ]]; then
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  else
    git -C ~/.oh-my-zsh pull
  fi
fi
