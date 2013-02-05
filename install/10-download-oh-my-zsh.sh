#!/bin/sh

if [[ -d ~/.oh-my-zsh ]]; then
  echo "oh-my-zsh is already installed"
  exit 0
fi

git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh



