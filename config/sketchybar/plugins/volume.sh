#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"

# volume_change passes the new level in $INFO; fall back to a query on first paint.
VOL="$INFO"
[ -z "$VOL" ] && VOL="$(/usr/bin/osascript -e 'output volume of (get volume settings)')"
[ -z "$VOL" ] && exit 0

if   [ "$VOL" -eq 0 ];  then ICON="󰖁"
elif [ "$VOL" -lt 34 ]; then ICON="󰕿"
elif [ "$VOL" -lt 67 ]; then ICON="󰖀"
else                         ICON="󰕾"
fi

sketchybar --set "$NAME" icon="$ICON" label="${VOL}%"
