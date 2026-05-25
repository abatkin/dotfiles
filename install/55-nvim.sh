#!/bin/bash

NVIM_CONFIG=$HOME/.config/nvim
NVIM_DOTFILES=$DOTFILES_ROOT/nvim
NVIM_LOCAL=$HOME/.config/nvim-local
INSTALL_DOTFILE=$DOTFILES_SCRIPTS/install-dotfile.sh

# If ~/.config/nvim is a whole-directory symlink, we can't safely place local files
# alongside dotfile files. Warn and bail rather than silently doing the wrong thing.
if [[ -L "$NVIM_CONFIG" ]]; then
  echo ""
  echo "WARNING: $NVIM_CONFIG is a directory symlink — skipping nvim setup."
  echo ""
  echo "This configuration expects $NVIM_CONFIG to be a real directory with"
  echo "individual file symlinks, so that machine-local files can coexist."
  echo ""
  echo "To migrate:"
  echo ""
  echo "  1. Back up machine-local files that live inside the symlinked directory"
  echo "     (these are gitignored and won't survive removing the symlink):"
  echo ""
  echo "       [[ -e $NVIM_CONFIG/lazyvim.json ]]   && cp $NVIM_CONFIG/lazyvim.json ~/lazyvim.json.bak"
  echo "       [[ -e $NVIM_CONFIG/lazy-lock.json ]] && cp $NVIM_CONFIG/lazy-lock.json ~/lazy-lock.json.bak"
  echo ""
  echo "  2. Remove the old symlink:"
  echo ""
  echo "       rm $NVIM_CONFIG"
  echo ""
  echo "  3. Re-run the install script, then restore your backups:"
  echo ""
  echo "       cp ~/lazyvim.json.bak $NVIM_CONFIG/lazyvim.json"
  echo "       cp ~/lazy-lock.json.bak $NVIM_CONFIG/lazy-lock.json"
  echo ""
  echo "  4. Migrate any machine-local hook files to $NVIM_LOCAL:"
  echo ""
  echo "     These files are no longer loaded from their old locations."
  echo "     Create the new directory structure and move them:"
  echo ""
  echo "       mkdir -p $NVIM_LOCAL/lua/config $NVIM_LOCAL/lua/plugins"
  echo ""
  echo "       # Options (was ~/.nvim-local-pre.lua):"
  echo "       [[ -e ~/.nvim-local-pre.lua ]] && mv ~/.nvim-local-pre.lua $NVIM_LOCAL/lua/config/options.lua"
  echo ""
  echo "     Any machine-local plugins go in $NVIM_LOCAL/lua/plugins/*.lua"
  echo ""
  exit 0
fi

mkdir -p "$NVIM_CONFIG/lua/config" "$NVIM_CONFIG/lua/plugins"
mkdir -p "$NVIM_LOCAL/lua/config" "$NVIM_LOCAL/lua/plugins"

$INSTALL_DOTFILE "$NVIM_DOTFILES" init.lua .config/nvim/init.lua

for _f in options keymaps autocmds lazy; do
  $INSTALL_DOTFILE "$NVIM_DOTFILES/lua/config" "$_f.lua" ".config/nvim/lua/config/$_f.lua"
done

for _f in "$NVIM_DOTFILES/lua/plugins/"*.lua; do
  [[ -e "$_f" ]] || continue  # skip if glob found nothing
  _basename=$(basename "$_f")
  $INSTALL_DOTFILE "$NVIM_DOTFILES/lua/plugins" "$_basename" ".config/nvim/lua/plugins/$_basename"
done

# lazyvim.json is machine-local (gitignored in dotfiles repo).
# Create a minimal one on first install; thereafter managed by :LazyExtras.
if [[ ! -e "$NVIM_CONFIG/lazyvim.json" ]]; then
  echo "Creating $NVIM_CONFIG/lazyvim.json"
  echo '{"extras":[],"install_version":7,"news":{},"version":8}' > "$NVIM_CONFIG/lazyvim.json"
fi
