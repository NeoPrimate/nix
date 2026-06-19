#!/usr/bin/env bash
# Full recompute: query aerospace, build per-workspace app-icon strips, write a
# cache snapshot for the fast focus path, then repaint. Runs on window/app
# changes and on a slow timer — NOT on the critical workspace-switch path.
source "$HOME/.config/sketchybar/colors.sh"
source "$(command -v icon_map.sh)"   # provides __icon_map -> $icon_result
STATE="${TMPDIR:-/tmp}/sketchybar_aerospace_state.sh"

FOCUSED="${FOCUSED:-$(aerospace list-workspaces --focused)}"
ALL_WS="$(aerospace list-workspaces --all | tr '\n' ' ')"

# Single fork-free pass over all windows -> de-duplicated glyph strip per ws.
while IFS='|' read -r sid app; do
  [ -z "$sid" ] && continue
  __icon_map "$app"
  ic="$icon_result"
  var="ws_${sid//[^a-zA-Z0-9]/_}"
  cur="${!var}"
  case " $cur " in
    *" $ic "*) ;;
    *) printf -v "$var" '%s' "${cur}${cur:+ }$ic" ;;
  esac
done < <(aerospace list-windows --all --format '%{workspace}|%{app-name}')

# Persist snapshot the fast path can `source` (ALL_WS + ws_<sid> vars).
{
  printf 'ALL_WS=%q\n' "$ALL_WS"
  for sid in $ALL_WS; do
    var="ws_${sid//[^a-zA-Z0-9]/_}"
    printf '%s=%q\n' "$var" "${!var}"
  done
} > "$STATE"

# Repaint everything (icons may have changed).
args=()
for sid in $ALL_WS; do
  var="ws_${sid//[^a-zA-Z0-9]/_}"
  icons="${!var}"
  if [ "$sid" = "$FOCUSED" ]; then
    args+=(--set space."$sid" drawing=on
           background.color="$ACCENT" icon.color="$BASE" label.color="$BASE"
           label="$icons")
  elif [ -n "$icons" ]; then
    args+=(--set space."$sid" drawing=on
           background.color="$SURFACE0" icon.color="$TEXT" label.color="$TEXT"
           label="$icons")
  else
    args+=(--set space."$sid" drawing=off)
  fi
done
sketchybar "${args[@]}"
