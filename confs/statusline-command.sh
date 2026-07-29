#!/usr/bin/env bash
# Claude Code status line
# Shows: model + reasoning/thinking, dir, git branch+state, context %,
#        5h & 7d rate limits, plus PR/agent state when present.
# Docs: https://code.claude.com/docs/en/statusline
#
# Install:
#   cp statusline.sh ~/.claude/statusline.sh
#   chmod +x ~/.claude/statusline.sh
# settings.json:
#   { "statusLine": { "type": "command", "command": "~/.claude/statusline.sh", "padding": 1 } }
#
# Requires: jq

input=$(cat)

# ---- helpers -------------------------------------------------------------
j() { printf '%s' "$input" | jq -r "$1"; }

# ---- colors --------------------------------------------------------------
CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'
BLUE='\033[34m'; MAGENTA='\033[35m'; DIM='\033[2m'; BOLD='\033[1m'; RESET='\033[0m'

# ---- core fields ---------------------------------------------------------
MODEL=$(j '.model.display_name')
DIR=$(j '.workspace.current_dir')
SESSION_ID=$(j '.session_id')
EFFORT=$(j '.effort.level // empty')
THINKING=$(j '.thinking.enabled // false')
PCT=$(j '.context_window.used_percentage // 0' | cut -d. -f1)
CTX_SIZE=$(j '.context_window.context_window_size // 200000')
AGENT=$(j '.agent.name // empty')
OUTPUT_STYLE=$(j '.output_style.name // empty')
PR_NUM=$(j '.pr.number // empty')
PR_STATE=$(j '.pr.review_state // empty')
FIVE_H=$(j '.rate_limits.five_hour.used_percentage // empty')
WEEK=$(j '.rate_limits.seven_day.used_percentage // empty')
FIVE_H_RESET=$(j '.rate_limits.five_hour.resets_at // empty')
WEEK_RESET=$(j '.rate_limits.seven_day.resets_at // empty')

# ---- model + reasoning ---------------------------------------------------
MODEL_SEG="${BOLD}${CYAN}${MODEL}${RESET}"
REASON=""
[ -n "$EFFORT" ] && REASON="${REASON} ${MAGENTA}⚡${EFFORT}${RESET}"
[ "$THINKING" = "true" ] && REASON="${REASON} ${MAGENTA}🧠${RESET}"

# ---- agent / output style (closest thing to "run state") -----------------
STATE=""
[ -n "$AGENT" ] && STATE="${STATE} ${YELLOW}🤖${AGENT}${RESET}"
[ -n "$OUTPUT_STYLE" ] && [ "$OUTPUT_STYLE" != "default" ] && STATE="${STATE} ${DIM}(${OUTPUT_STYLE})${RESET}"

# ---- git (cached 5s; runs on every refresh otherwise) --------------------
CACHE_FILE="/tmp/claude-statusline-git-${SESSION_ID}"
CACHE_MAX_AGE=5
cache_mtime() { stat -c %Y "$CACHE_FILE" 2>/dev/null || stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0; }
cache_is_stale() {
  [ ! -f "$CACHE_FILE" ] || [ $(( $(date +%s) - $(cache_mtime) )) -gt "$CACHE_MAX_AGE" ]
}

if cache_is_stale; then
  if git -C "$DIR" rev-parse --git-dir >/dev/null 2>&1; then
    BRANCH=$(git -C "$DIR" branch --show-current 2>/dev/null)
    STAGED=$(git -C "$DIR" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    MODIFIED=$(git -C "$DIR" diff --numstat 2>/dev/null | wc -l | tr -d ' ')
    UNTRACKED=$(git -C "$DIR" ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
    # ahead/behind vs upstream
    AB=$(git -C "$DIR" rev-list --left-right --count '@{u}...HEAD' 2>/dev/null)
    BEHIND=$(printf '%s' "$AB" | awk '{print $1}'); AHEAD=$(printf '%s' "$AB" | awk '{print $2}')
    printf '%s|%s|%s|%s|%s|%s\n' "$BRANCH" "$STAGED" "$MODIFIED" "$UNTRACKED" "${AHEAD:-0}" "${BEHIND:-0}" > "$CACHE_FILE"
  else
    printf '|||||\n' > "$CACHE_FILE"
  fi
fi
IFS='|' read -r BRANCH STAGED MODIFIED UNTRACKED AHEAD BEHIND < "$CACHE_FILE"

GIT_SEG=""
if [ -n "$BRANCH" ]; then
  GIT_SEG=" ${DIM}|${RESET} ${GREEN}⎇ ${BRANCH}${RESET}"
  [ "${AHEAD:-0}" -gt 0 ] 2>/dev/null && GIT_SEG="${GIT_SEG} ${CYAN}↑${AHEAD}${RESET}"
  [ "${BEHIND:-0}" -gt 0 ] 2>/dev/null && GIT_SEG="${GIT_SEG} ${CYAN}↓${BEHIND}${RESET}"
  CHANGES=""
  [ "${STAGED:-0}" -gt 0 ] 2>/dev/null && CHANGES="${CHANGES}${GREEN}●${STAGED}${RESET}"
  [ "${MODIFIED:-0}" -gt 0 ] 2>/dev/null && CHANGES="${CHANGES}${YELLOW}+${MODIFIED}${RESET}"
  [ "${UNTRACKED:-0}" -gt 0 ] 2>/dev/null && CHANGES="${CHANGES}${RED}?${UNTRACKED}${RESET}"
  [ -n "$CHANGES" ] && GIT_SEG="${GIT_SEG} ${CHANGES}" || GIT_SEG="${GIT_SEG} ${DIM}clean${RESET}"
fi

# ---- PR state ------------------------------------------------------------
PR_SEG=""
if [ -n "$PR_NUM" ]; then
  case "$PR_STATE" in
    approved)          PR_SEG=" ${DIM}|${RESET} ${GREEN}PR#${PR_NUM}✓${RESET}" ;;
    changes_requested) PR_SEG=" ${DIM}|${RESET} ${RED}PR#${PR_NUM}✗${RESET}" ;;
    draft)             PR_SEG=" ${DIM}|${RESET} ${DIM}PR#${PR_NUM}…${RESET}" ;;
    *)                 PR_SEG=" ${DIM}|${RESET} ${YELLOW}PR#${PR_NUM}${RESET}" ;;
  esac
fi

# ---- context bar ---------------------------------------------------------
if   [ "$PCT" -ge 90 ]; then CTX_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then CTX_COLOR="$YELLOW"
else CTX_COLOR="$GREEN"; fi
FILLED=$((PCT / 10)); EMPTY=$((10 - FILLED))
[ "$FILLED" -lt 0 ] && FILLED=0; [ "$EMPTY" -lt 0 ] && EMPTY=0
printf -v FILL "%${FILLED}s"; printf -v PAD "%${EMPTY}s"
CTX_BAR="${FILL// /█}${PAD// /░}"
# note 1M-context models for context
CTX_NOTE=""; [ "$CTX_SIZE" -ge 1000000 ] 2>/dev/null && CTX_NOTE="${DIM}(1M)${RESET}"
CTX_SEG="${CTX_COLOR}${CTX_BAR}${RESET} ${CTX_COLOR}${PCT}%${RESET}${CTX_NOTE}"

# ---- rate limits ---------------------------------------------------------
rl_color() { local p=${1%.*}; if [ "$p" -ge 90 ]; then printf '%b' "$RED"; elif [ "$p" -ge 70 ]; then printf '%b' "$YELLOW"; else printf '%b' "$GREEN"; fi; }

# pretty_reset EPOCH -> human "time until reset"
#   < 1h   -> 45m
#   < 1d   -> 1h30m   (minutes dropped when zero, e.g. 3h)
#   >= 1d  -> weekday + local time, e.g. "Thu 14:00"  (more useful than 6d3h)
# Past/now -> "now"
pretty_reset() {
  local target=$1 now diff d h m
  now=$(date +%s); diff=$(( target - now ))
  [ "$diff" -le 0 ] && { printf 'now'; return; }
  if [ "$diff" -lt 86400 ]; then
    h=$(( diff / 3600 )); m=$(( (diff % 3600) / 60 ))
    if [ "$h" -gt 0 ]; then
      [ "$m" -gt 0 ] && printf '%dh%dm' "$h" "$m" || printf '%dh' "$h"
    else
      printf '%dm' "$m"
    fi
  else
    # weekday + HH:MM in local time (GNU: -d @epoch; BSD/macOS: -r epoch)
    date -d "@$target" '+%a %H:%M' 2>/dev/null || date -r "$target" '+%a %H:%M' 2>/dev/null \
      || { d=$(( diff / 86400 )); h=$(( (diff % 86400) / 3600 )); printf '%dd%dh' "$d" "$h"; }
  fi
}

RL_SEG=""
if [ -n "$FIVE_H" ]; then
  C=$(rl_color "$FIVE_H")
  RESET_NOTE=""
  [ -n "$FIVE_H_RESET" ] && RESET_NOTE="${DIM}↻$(pretty_reset "$FIVE_H_RESET")${RESET}"
  RL_SEG="${RL_SEG} ${C}5h $(printf '%.0f' "$FIVE_H")%${RESET}${RESET_NOTE}"
fi
if [ -n "$WEEK" ]; then
  C=$(rl_color "$WEEK")
  RESET_NOTE=""
  [ -n "$WEEK_RESET" ] && RESET_NOTE="${DIM}↻$(pretty_reset "$WEEK_RESET")${RESET}"
  RL_SEG="${RL_SEG} ${C}7d $(printf '%.0f' "$WEEK")%${RESET}${RESET_NOTE}"
fi

# ---- assemble ------------------------------------------------------------
# Line 1: identity, location, git, PR
printf '%b\n' "${MODEL_SEG}${REASON}${STATE} ${DIM}|${RESET} ${BLUE}📁 ${DIR##*/}${RESET}${GIT_SEG}${PR_SEG}"
# Line 2: context + rate limits
printf '%b\n' "${CTX_SEG}${RL_SEG:+ ${DIM}|${RESET}${RL_SEG}}"
