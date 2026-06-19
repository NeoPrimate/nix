#!/usr/bin/env bash
# Re-render every workspace item in a single pass.
# Queries aerospace twice total (focused + all windows), no per-item shelling.
source "$HOME/.config/sketchybar/colors.sh"
source "$(command -v icon_map.sh)"   # provides __icon_map -> $icon_result

FOCUSED="$(aerospace list-workspaces --focused)"
WINDOWS="$(aerospace list-windows --all --format '%{workspace}|%{app-name}')"

args=()
for sid in $(aerospace list-workspaces --all); do
  # collect de-duplicated app glyphs for this workspace
  icons=""
  while IFS= read -r app; do
    [ -z "$app" ] && continue
    __icon_map "$app"
    ic="$icon_result"
    case " $icons " in
      *" $ic "*) ;;                       # already present
      *) icons="$icons${icons:+ }$ic" ;;
    esac
  done < <(printf '%s\n' "$WINDOWS" | awk -F'|' -v w="$sid" '$1==w {print $2}')

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
