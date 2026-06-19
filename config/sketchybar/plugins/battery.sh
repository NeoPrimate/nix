#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"

BATT="$(/usr/bin/pmset -g batt)"
PCT="$(printf '%s' "$BATT" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')"
[ -z "$PCT" ] && exit 0
CHARGING="$(printf '%s' "$BATT" | grep -c 'AC Power')"

case "$PCT" in
  100|9[0-9])  ICON="󰁹"; COLOR="$GREEN"  ;;
  [7-8][0-9])  ICON="󰂁"; COLOR="$GREEN"  ;;
  [4-6][0-9])  ICON="󰁾"; COLOR="$YELLOW" ;;
  [2-3][0-9])  ICON="󰁻"; COLOR="$PEACH"  ;;
  *)           ICON="󰁺"; COLOR="$RED"    ;;
esac

if [ "$CHARGING" -gt 0 ]; then
  ICON="󰂄"; COLOR="$GREEN"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PCT}%"
