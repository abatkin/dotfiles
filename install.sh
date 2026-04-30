#!/usr/bin/env bash
#
# Dotfiles installer driver.
#
# Discovers stages in install/*.sh (lexical order), sources each one in the
# driver's environment so they share helpers from lib/common.sh, and supports
# selective execution and dry runs.
#
set -euo pipefail

DOTFILES_ROOT=$(cd "$(dirname "$0")" && pwd -P)
export DOTFILES_ROOT
export DOTFILES_SCRIPTS="$DOTFILES_ROOT/scripts"
export DOTFILES_LIB="$DOTFILES_ROOT/lib"

export DRY_RUN=false
export LOCAL_ONLY="${LOCAL_ONLY:-false}"

ONLY=""
SKIP=""

usage() {
  cat <<EOF
Usage: $(basename "$0") [options]

Options:
  --dry-run         Print actions without modifying anything.
  --local-only      Skip network operations (git clone/pull).
  --only NAMES      Comma-separated stage name substrings to run.
  --skip NAMES      Comma-separated stage name substrings to skip.
  -h, --help        Show this help message.

Stages live in $DOTFILES_ROOT/install/*.sh and run in lexical order.
Local overrides are sourced from ~/.dotfiles-local before any stage runs.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)     DRY_RUN=true ;;
    --local-only)  LOCAL_ONLY=true ;;
    --only)        ONLY="${2:?--only requires an argument}"; shift ;;
    --only=*)      ONLY="${1#--only=}" ;;
    --skip)        SKIP="${2:?--skip requires an argument}"; shift ;;
    --skip=*)      SKIP="${1#--skip=}" ;;
    -h|--help)     usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

# Source per-host local overrides BEFORE the library so the user can pre-set
# DRY_RUN, LOCAL_ONLY, BLACKLIST_VIM_MODULES, etc.
if [[ -e "$HOME/.dotfiles-local" ]]; then
  # shellcheck disable=SC1091
  . "$HOME/.dotfiles-local"
fi

# shellcheck disable=SC1091
. "$DOTFILES_LIB/common.sh"

stage_selected() {
  local name="$1" pat
  if [[ -n "$ONLY" ]]; then
    local IFS=, matched=false
    for pat in $ONLY; do
      [[ "$name" == *"$pat"* ]] && matched=true
    done
    $matched || return 1
  fi
  if [[ -n "$SKIP" ]]; then
    local IFS=,
    for pat in $SKIP; do
      [[ "$name" == *"$pat"* ]] && return 1
    done
  fi
  return 0
}

log_info "DOTFILES_ROOT=$DOTFILES_ROOT"
[[ "$DRY_RUN"    == "true" ]] && log_info "DRY_RUN enabled"
[[ "$LOCAL_ONLY" == "true" ]] && log_info "LOCAL_ONLY enabled (no network)"

shopt -s nullglob
for stage in "$DOTFILES_ROOT"/install/*.sh; do
  name=$(basename "$stage" .sh)
  if ! stage_selected "$name"; then
    log_info "Skipping stage: $name"
    continue
  fi
  log_info "==> Stage: $name"
  # shellcheck disable=SC1090
  . "$stage"
done

log_info "Done."
