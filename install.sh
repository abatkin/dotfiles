#!/bin/bash

export DOTFILES_ROOT=$(cd "$(dirname "$0")" && pwd)

DRY_RUN=false
for _arg in "$@"; do
  case "$_arg" in
    --dry-run|-n) DRY_RUN=true ;;
    *) echo "Unknown argument: $_arg" >&2; exit 1 ;;
  esac
done
export DRY_RUN
unset _arg

source "$DOTFILES_ROOT/install/lib.sh"

[[ "$DRY_RUN" == "true" ]] && echo "(dry-run mode — no changes will be made)"

for _installer in "$DOTFILES_ROOT"/install/[0-9]*.sh; do
  echo "==> $(basename $_installer)"
  source "$_installer"
done
unset _installer
