#!/usr/bin/env bash
set -euo pipefail

THEME="$HOME/.config/rofi/themes/apps-grid.rasi"

# Sauvegarde blur
OLD_SIZE="$(hyprctl getoption decoration:blur:size   | awk '/int:/ {print $2; exit}')"
OLD_PASSES="$(hyprctl getoption decoration:blur:passes | awk '/int:/ {print $2; exit}')"
OLD_IGNORE="$(hyprctl getoption decoration:blur:ignore_opacity | awk '/int:/ {print $2; exit}')"

# Boost blur
hyprctl keyword decoration:blur:size 10 >/dev/null
hyprctl keyword decoration:blur:passes "$OLD_PASSES" >/dev/null
hyprctl keyword decoration:blur:ignore_opacity "$OLD_IGNORE" >/dev/null

# Tue waybar → rofi prend tout l'écran
kill $(pgrep waybar) 2>/dev/null || true

# Rofi bloquant — Hyprland s'occupe du placement via windowrulev2
rofi -show drun -theme "$THEME"

# Restore blur
hyprctl keyword decoration:blur:size    "$OLD_SIZE"   >/dev/null
hyprctl keyword decoration:blur:passes  "$OLD_PASSES" >/dev/null
hyprctl keyword decoration:blur:ignore_opacity "$OLD_IGNORE" >/dev/null

# Relance waybar en arrière-plan
waybar </dev/null >/dev/null 2>&1 &
disown
