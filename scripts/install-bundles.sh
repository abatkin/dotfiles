#!/usr/bin/env bash
#
# Clone or update a list of git repositories into INSTALL_DIR.
#
# REPOLIST is a text file where each non-empty, non-comment line is:
#     URL [name]
# If `name` is omitted the directory name is derived from URL.
#
# Honors environment:
#   LOCAL_ONLY=true   skip all network operations
#   DRY_RUN=true      print actions only
#   DOTFILES_LIB      directory containing common.sh (auto-detected if unset)
#
set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "Usage: $(basename "$0") repolist installdir description [blacklist]" >&2
  exit 1
fi

REPOLIST="$1"
INSTALL_DIR="$2"
DESCRIPTION="$3"
BLACKLIST="${4:-}"

# Locate and source the shared helpers.
if [[ -z "${DOTFILES_LIB:-}" ]]; then
  DOTFILES_LIB="$(cd "$(dirname "$0")/../lib" && pwd -P)"
fi
# shellcheck disable=SC1091
. "$DOTFILES_LIB/common.sh"

if [[ "${LOCAL_ONLY:-false}" == "true" ]]; then
  log_info "[$DESCRIPTION] LOCAL_ONLY set; skipping bundle install"
  exit 0
fi

if [[ ! -r "$REPOLIST" ]]; then
  log_error "[$DESCRIPTION] cannot read repo list: $REPOLIST"
  exit 1
fi

ensure_dir "$INSTALL_DIR"

is_blacklisted() {
  local name="$1" entry
  for entry in $BLACKLIST; do
    [[ "$entry" == "$name" ]] && return 0
  done
  return 1
}

while IFS= read -r line || [[ -n "$line" ]]; do
  # Strip leading/trailing whitespace, skip blanks and comments.
  line="${line#"${line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"
  [[ -z "$line" || "$line" == \#* ]] && continue

  read -r url name <<<"$line"
  if [[ -z "${name:-}" ]]; then
    name="${url##*/}"
    name="${name%.git}"
  fi

  if is_blacklisted "$name"; then
    log_info "[$DESCRIPTION] Skipping blacklisted bundle $name"
    continue
  fi

  log_info "[$DESCRIPTION] $name"
  clone_or_update "$url" "$INSTALL_DIR/$name"
done < "$REPOLIST"
