#!/usr/bin/env bash
# Updates both the date and time items from one timer tick.
sketchybar --set clock label="$(date '+%H:%M')" \
           --set cal   label="$(date '+%a %d %b')"
