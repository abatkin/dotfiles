#!/bin/bash

_nvim_config=~/.config/nvim
_nvim_dotfiles="$DOTFILES_ROOT/nvim"
_nvim_local=~/.config/nvim-local

# If ~/.config/nvim is a whole-directory symlink, we can't safely place local files
# alongside dotfile files. Warn and bail rather than silently doing the wrong thing.
if [[ -L "$_nvim_config" ]]; then
  echo ""
  echo "WARNING: $_nvim_config is a directory symlink — skipping nvim setup."
  echo ""
  echo "This configuration expects $_nvim_config to be a real directory with"
  echo "individual file symlinks, so that machine-local files can coexist."
  echo ""
  echo "To migrate:"
  echo ""
  echo "  1. Back up machine-local files that live inside the symlinked directory"
  echo "     (these are gitignored and won't survive removing the symlink):"
  echo ""
  echo "       [[ -e $_nvim_config/lazyvim.json ]]   && cp $_nvim_config/lazyvim.json ~/lazyvim.json.bak"
  echo "       [[ -e $_nvim_config/lazy-lock.json ]] && cp $_nvim_config/lazy-lock.json ~/lazy-lock.json.bak"
  echo ""
  echo "  2. Remove the old symlink:"
  echo ""
  echo "       rm $_nvim_config"
  echo ""
  echo "  3. Re-run the install script, then restore your backups:"
  echo ""
  echo "       cp ~/lazyvim.json.bak $_nvim_config/lazyvim.json"
  echo "       cp ~/lazy-lock.json.bak $_nvim_config/lazy-lock.json"
  echo ""
  echo "  4. Migrate any machine-local hook files to $_nvim_local:"
  echo ""
  echo "     These files are no longer loaded from their old locations."
  echo "     Create the new directory structure and move them:"
  echo ""
  echo "       mkdir -p $_nvim_local/lua/config $_nvim_local/lua/plugins"
  echo ""
  echo "       # Options (was ~/.nvim-local-pre.lua):"
  echo "       [[ -e ~/.nvim-local-pre.lua ]] && mv ~/.nvim-local-pre.lua $_nvim_local/lua/config/options.lua"
  echo ""
  echo "     Any machine-local plugins go in $_nvim_local/lua/plugins/*.lua"
  echo ""
  unset _nvim_config _nvim_dotfiles _nvim_local
  return 0
fi

mkdir -p "$_nvim_config/lua/config" "$_nvim_config/lua/plugins"
mkdir -p "$_nvim_local/lua/config" "$_nvim_local/lua/plugins"

install_dotfile "$_nvim_dotfiles" init.lua .config/nvim/init.lua

for _f in options keymaps autocmds lazy; do
  install_dotfile "$_nvim_dotfiles/lua/config" "$_f.lua" ".config/nvim/lua/config/$_f.lua"
done

for _f in "$_nvim_dotfiles/lua/plugins/"*.lua; do
  [[ -e "$_f" ]] || continue
  install_dotfile "$_nvim_dotfiles/lua/plugins" "$(basename $_f)" ".config/nvim/lua/plugins/$(basename $_f)"
done

if [[ ! -e "$_nvim_config/lazyvim.json" ]]; then
  echo "Creating $_nvim_config/lazyvim.json"
  echo '{"extras":[],"install_version":7,"news":{},"version":8}' > "$_nvim_config/lazyvim.json"
fi

unset _nvim_config _nvim_dotfiles _nvim_local _f
