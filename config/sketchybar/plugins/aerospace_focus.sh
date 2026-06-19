#!/usr/bin/env bash
# Fast path: move the workspace highlight with NO aerospace queries.
# Invoked DIRECTLY by aerospace's exec-on-workspace-change (no sketchybar event
# round-trip). Reads focused/previous workspace from aerospace's env and the
# cached icon strips written by aerospace_icons.sh.
source "$HOME/.config/sketchybar/colors.sh"
STATE="${TMPDIR:-/tmp}/sketchybar_aerospace_state.sh"

FOCUSED="${FOCUSED:-$AEROSPACE_FOCUSED_WORKSPACE}"
PREV="${PREV:-$AEROSPACE_PREV_WORKSPACE}"

# shellcheck disable=SC1090
[ -f "$STATE" ] && source "$STATE"

# No cache or no focus info -> full recompute (which also rewrites the cache).
if [ -z "${ALL_WS:-}" ] || [ -z "$FOCUSED" ]; then
  exec "$HOME/.config/sketchybar/plugins/aerospace_icons.sh"
fi

args=()
add() {  # $1 = sid, $2 = 1 if focused
  local sid="$1" var icons
  var="ws_${sid//[^a-zA-Z0-9]/_}"
  icons="${!var}"
  if [ "$2" = 1 ]; then
    args+=(--set space."$sid" drawing=on
           background.color="$ACCENT" icon.color="$BASE" label.color="$BASE" label="$icons")
  elif [ -n "$icons" ]; then
    args+=(--set space."$sid" drawing=on
           background.color="$SURFACE0" icon.color="$TEXT" label.color="$TEXT" label="$icons")
  else
    args+=(--set space."$sid" drawing=off)
  fi
}

if [ -n "$PREV" ] && [ "$PREV" != "$FOCUSED" ]; then
  add "$PREV" 0          # only the two affected workspaces
  add "$FOCUSED" 1
else
  for sid in $ALL_WS; do # first switch / PREV unknown -> repaint all
    [ "$sid" = "$FOCUSED" ] && add "$sid" 1 || add "$sid" 0
  done
fi

sketchybar "${args[@]}"
