#!/usr/bin/env bash
# Shared helpers for the dotfiles installer.
#
# The driver (install.sh) is expected to set:
#   DOTFILES_ROOT     absolute path to this repository
#   DOTFILES_SCRIPTS  $DOTFILES_ROOT/scripts
#   DOTFILES_LIB      $DOTFILES_ROOT/lib
#   DRY_RUN           "true" or "false"
#   LOCAL_ONLY        "true" or "false"
#
# When sourced, this file is safe to source repeatedly.

# Guard against double-sourcing.
if [[ -n "${_DOTFILES_COMMON_LOADED:-}" ]]; then
  return 0 2>/dev/null || exit 0
fi
_DOTFILES_COMMON_LOADED=1

# Sensible defaults if the driver did not set them.
: "${DRY_RUN:=false}"
: "${LOCAL_ONLY:=false}"

# --- Logging --------------------------------------------------------------
# Colors are only emitted when stdout is a terminal.
if [[ -t 1 ]]; then
  _C_INFO=$'\033[1;34m'
  _C_WARN=$'\033[1;33m'
  _C_ERR=$'\033[1;31m'
  _C_DRY=$'\033[1;35m'
  _C_OFF=$'\033[0m'
else
  _C_INFO=''; _C_WARN=''; _C_ERR=''; _C_DRY=''; _C_OFF=''
fi

log_info()  { printf '%s[INFO]%s  %s\n'  "$_C_INFO" "$_C_OFF" "$*"; }
log_warn()  { printf '%s[WARN]%s  %s\n'  "$_C_WARN" "$_C_OFF" "$*" >&2; }
log_error() { printf '%s[ERROR]%s %s\n'  "$_C_ERR"  "$_C_OFF" "$*" >&2; }
log_dry()   { printf '%s[DRY]%s   %s\n'  "$_C_DRY"  "$_C_OFF" "$*"; }

# --- Dry-run wrapper ------------------------------------------------------
# Usage: run cmd args...
run() {
  if [[ "$DRY_RUN" == "true" ]]; then
    log_dry "$*"
  else
    "$@"
  fi
}

# --- Filesystem helpers ---------------------------------------------------
ensure_dir() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    run mkdir -p "$dir"
  fi
}

# Symlink src -> dst.
# - Backs up an existing dst (file/dir) to dst.old.
# - Idempotent: if dst is already a symlink to src, does nothing.
# - Creates the parent directory of dst if missing.
link() {
  local src="$1" dst="$2"

  if [[ ! -e "$src" && ! -L "$src" ]]; then
    log_warn "link: source does not exist: $src"
    return 1
  fi

  ensure_dir "$(dirname "$dst")"

  if [[ -L "$dst" ]]; then
    local current
    current=$(readlink "$dst")
    if [[ "$current" == "$src" ]]; then
      return 0
    fi
  fi

  if [[ -e "$dst" || -L "$dst" ]]; then
    local backup="$dst.old"
    log_info "Backing up $dst -> $backup"
    run mv "$dst" "$backup"
  fi

  log_info "Linking $dst -> $src"
  run ln -s "$src" "$dst"
}

# Copy src -> dst only if dst does not exist.
# Used for "template" configs the user is expected to edit afterwards.
copy_template() {
  local src="$1" dst="$2"
  if [[ -e "$dst" ]]; then
    return 0
  fi
  ensure_dir "$(dirname "$dst")"
  log_info "Copying template $src -> $dst"
  run cp "$src" "$dst"
}

# Clone repo into dir if missing, otherwise pull.
# Skips entirely when LOCAL_ONLY=true.
clone_or_update() {
  local url="$1" dir="$2"

  if [[ "$LOCAL_ONLY" == "true" ]]; then
    return 0
  fi

  if [[ ! -d "$dir" ]]; then
    log_info "Cloning $url -> $dir"
    run git clone "$url" "$dir"
    return 0
  fi

  log_info "Updating $dir"

  local current_branch current_remote current_url
  current_branch=$(git -C "$dir" symbolic-ref -q --short HEAD 2>/dev/null || true)
  current_remote=$(git -C "$dir" config "branch.${current_branch}.remote" 2>/dev/null || true)
  current_url=$(git -C "$dir" config "remote.${current_remote}.url" 2>/dev/null || true)

  if [[ -z "$current_remote" ]]; then
    log_warn "Unable to determine branch/remote for $dir"
    return 0
  fi

  if [[ "$current_url" != "$url" ]]; then
    log_warn "$dir appears to have switched remotes ($current_url => $url)"
    return 0
  fi

  run git -C "$dir" pull --ff-only
}
