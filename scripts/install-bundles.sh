#!/bin/zsh

if [[ $# -lt 3 ]]; then
  echo "Usage: $(basename $0) repolist installdir description [blacklist]"
  exit 1
fi

if [[ "$LOCAL_ONLY" == "true" ]]; then
  exit 0
fi

REPOLIST="$1"
INSTALL_DIR="$2"
DESCRIPTION="$3"
BLACKLIST="$4"

while IFS="\n" read -r BUNDLE_LINE || [[ -n "$BUNDLE_LINE" ]]; do
  echo "$BUNDLE_LINE" | IFS=" " read -r BUNDLE_URL BUNDLE_NAME
  if [[ -z $BUNDLE_NAME ]]; then
    BUNDLE_NAME=$(echo "$BUNDLE_URL" | sed -e 's/.*\///' -e 's/\.git$//')
  fi

  SKIP_MODULE=0
  for EXCLUDE in $(echo $BLACKLIST); do
    if [[ "$EXCLUDE" == "$BUNDLE_NAME" ]]; then
      SKIP_MODULE=1
    fi
  done

  if [[ $SKIP_MODULE == 0 ]]; then
    if [[ ! -d $INSTALL_DIR/$BUNDLE_NAME ]]; then
      echo "[$DESCRIPTION] Adding bundle for $BUNDLE_NAME"
      git clone "$BUNDLE_URL" $INSTALL_DIR/$BUNDLE_NAME
    else
      pushd $INSTALL_DIR/$BUNDLE_NAME
      echo "[$DESCRIPTION] Updating $BUNDLE_NAME ($BUNDLE_URL)"
      CURRENT_BRANCH=$(git symbolic-ref -q --short HEAD) > /dev/null 2>&1
      CURRENT_REMOTE=$(git config branch.${CURRENT_BRANCH}.remote) > /dev/null 2>&1
      CURRENT_REMOTE_URL=$(git config remote.${CURRENT_REMOTE}.url) > /dev/null 2>&1
      if [[ -z $CURRENT_REMOTE ]]; then
        echo "[$DESCRIPTION] Unable to determine branch/remote for $BUNDLE_NAME"
      else
        if [[ $CURRENT_REMOTE_URL == $BUNDLE_URL ]]; then
          git pull
        else
          echo "[$DESCRIPTION] Warning: Bundle $BUNDLE_NAME appears to have switched remotes ($CURRENT_REMOTE_URL => $BUNDLE_URL)"
        fi
      fi
      popd
    fi
  else
    echo "[$DESCRIPTION] Skipping locally blacklisted bundle $BUNDLE_NAME"
  fi
done < $REPOLIST


