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

BUNDLE_DIR=~/.vim/bundle

if [[ "$LOCAL_ONLY" == "true" ]]; then
  exit 0
fi

for BUNDLE_URL in $(cat $DOTFILES_ROOT/vim/bundles.txt); do
  BUNDLE_NAME=$(echo "$BUNDLE_URL" | sed -e 's/.*\///' -e 's/\.git$//')
  SKIP_MODULE=0
  for EXCLUDE in $(echo $BLACKLIST_VIM_MODULES); do
    if [[ "$EXCLUDE" == "$BUNDLE_NAME" ]]; then
      SKIP_MODULE=1
    fi
  done

  if [[ $SKIP_MODULE == 0 ]]; then
    if [[ ! -d $BUNDLE_DIR/$BUNDLE_NAME ]]; then
      echo "Adding bundle for $BUNDLE_NAME"
      git clone "$BUNDLE_URL" $BUNDLE_DIR/$BUNDLE_NAME
    else
      pushd $BUNDLE_DIR/$BUNDLE_NAME
      git pull
      popd
    fi
  else
    echo "Skipping locally blacklisted Vim module $BUNDLE_NAME"
  fi
done


