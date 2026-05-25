#!/bin/bash

echo "Checking out oh-my-zsh"
if [[ "$LOCAL_ONLY" != "true" ]]; then
  if [[ ! -d ~/.oh-my-zsh ]]; then
    run git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  else
    run git -C ~/.oh-my-zsh pull
  fi
fi
