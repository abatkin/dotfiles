#!/bin/sh

if [[ $# -lt 3 ]]; then
  echo "Usage: $(basename $0) dotfilesDir fromFile toFile"
  exit 1
fi


FILE_DIR="$1"
FILE_FROM="$2"
FILE_TO="$3"

INSTALL_FILE=0

FILENAME_FROM="$FILE_DIR/$FILE_FROM"
FILENAME_TO=~/"$FILE_TO"
FILENAME_BACKUP="$FILENAME_TO.old"

if [[ -L "$FILENAME_TO" ]] && realpath "$FILENAME_TO" | grep "$DOTFILES_DIR" > /dev/null 2>&1; then
  echo "$FILE_TO looks like it is already installed"
  INSTALL_FILE=1
fi

if [[ -e "$FILENAME_TO" ]]; then
  echo "Backing up old $FILE_TO to $FILE_TO.old"
  mv "$FILENAME_TO" "$FILENAME_BACKUP"
fi

if [ $INSTALL_FILE ]; then
  ln -s "$FILENAME_FROM" "$FILENAME_TO"
fi

