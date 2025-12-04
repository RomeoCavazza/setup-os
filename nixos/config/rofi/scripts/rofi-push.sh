#!/usr/bin/env bash

# Config
WIDTH=110
ROFI_CMD="rofi -show drun -theme ~/.config/rofi/custom/column-tco.rasi -normal-window"

# Logic
if pgrep -x "rofi" > /dev/null; then
    pkill -x rofi
    hyprctl keyword monitor ,addreserved,0,0,0,0
    exit 0
else
    hyprctl keyword monitor ,addreserved,0,0,$WIDTH,0
    $ROFI_CMD
    hyprctl keyword monitor ,addreserved,0,0,0,0
fi
