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

while IFS="\n" read -r BUNDLE_LINE || [[ -n "$BUNDLE_LINE" ]]; do
  echo "$BUNDLE_LINE" | IFS=" " read -r BUNDLE_URL BUNDLE_NAME
  if [[ -z $BUNDLE_NAME ]]; then
    BUNDLE_NAME=$(echo "$BUNDLE_URL" | sed -e 's/.*\///' -e 's/\.git$//')
  fi

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
      echo "Updating $BUNDLE_NAME ($BUNDLE_URL)"
      CURRENT_BRANCH=$(git symbolic-ref -q --short HEAD) > /dev/null 2>&1
      CURRENT_REMOTE=$(git config branch.${CURRENT_BRANCH}.remote) > /dev/null 2>&1
      CURRENT_REMOTE_URL=$(git config remote.${CURRENT_REMOTE}.url) > /dev/null 2>&1
      if [[ -z $CURRENT_REMOTE ]]; then
        echo "Unable to determine branch/remote for $BUNDLE_NAME"
      else
        if [[ $CURRENT_REMOTE_URL == $BUNDLE_URL ]]; then
          git pull
        else
          echo "Warning: Bundle $BUNDLE_NAME appears to have switched remotes ($CURRENT_REMOTE => $BUNDLE_URL)"
        fi
      fi
      popd
    fi
  else
    echo "Skipping locally blacklisted Vim module $BUNDLE_NAME"
  fi
done < $DOTFILES_ROOT/vim/bundles.txt


