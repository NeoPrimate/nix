#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"

# Two samples so the figure reflects current load, not since-boot average.
CPU="$(/usr/bin/top -l 2 -n 0 | awk '/CPU usage/ {u=$3; s=$5} END {gsub("%","",u); gsub("%","",s); print int(u+s)}')"
[ -z "$CPU" ] && CPU=0

if   [ "$CPU" -gt 80 ]; then COLOR="$RED"
elif [ "$CPU" -gt 50 ]; then COLOR="$PEACH"
elif [ "$CPU" -gt 20 ]; then COLOR="$YELLOW"
else                         COLOR="$GREEN"
fi

sketchybar --set "$NAME" icon="󰻠" icon.color="$COLOR" label="${CPU}%"
