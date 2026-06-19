#!/usr/bin/env bash
# Full recompute: query aerospace, build per-workspace app-icon strips, write a
# cache snapshot for the fast focus path, then repaint. Runs on window/app
# changes and on a slow timer — NOT on the critical workspace-switch path.
source "$HOME/.config/sketchybar/colors.sh"
source "$(command -v icon_map.sh)"   # provides __icon_map -> $icon_result
# Literal /tmp (not $TMPDIR): the Rust focus helper reads this exact path, and
# macOS gives daemons a per-user $TMPDIR that aerospace's child wouldn't share.
STATE="/tmp/sketchybar_spaces"

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

# Cache for the Rust focus helper: which workspaces exist, and which are non-empty.
nonempty=""
for sid in $ALL_WS; do
  var="ws_${sid//[^a-zA-Z0-9]/_}"
  [ -n "${!var}" ] && nonempty="$nonempty$sid "
done
{
  printf 'ALL %s\n' "$ALL_WS"
  printf 'NONEMPTY %s\n' "$nonempty"
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
