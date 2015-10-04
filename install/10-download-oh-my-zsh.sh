#!/bin/zsh

echo "Checking out oh-my-zsh"
if [[ ! "$LOCAL_ONLY" == "true" ]]; then
  if [[ ! -d ~/.oh-my-zsh ]]; then
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  else
    pushd ~/.oh-my-zsh
    git pull
    popd
  fi
fi

