#!/usr/bin/env bash
set -euo pipefail

THEME="$HOME/.config/rofi/themes/apps-grid.rasi"
WAYBAR_CFG="$HOME/.config/waybar/config.jsonc"
WAYBAR_CSS="$HOME/.config/waybar/style.css"

getopt_int() { hyprctl getoption "$1" | awk '/int:/ {print $2; exit}'; }

OLD_SIZE="$(getopt_int decoration:blur:size)"
OLD_PASSES="$(getopt_int decoration:blur:passes)"
OLD_IGNORE="$(getopt_int decoration:blur:ignore_opacity)"

restore() {
  hyprctl keyword decoration:blur:size "$OLD_SIZE" >/dev/null 2>&1 || true
  hyprctl keyword decoration:blur:passes "$OLD_PASSES" >/dev/null 2>&1 || true
  hyprctl keyword decoration:blur:ignore_opacity "$OLD_IGNORE" >/dev/null 2>&1 || true

  # Relance waybar (toujours) — on laisse pas de conditions fragiles
  nohup waybar -c "$WAYBAR_CFG" -s "$WAYBAR_CSS" >/dev/null 2>&1 &
}
trap restore EXIT INT TERM

# Boost blur (léger)
hyprctl keyword decoration:blur:size 8 >/dev/null 2>&1

# Kill waybar (match cmdline, version nix/wrapped friendly)
pkill -u "$USER" -f 'waybar' 2>/dev/null || true

# Run rofi (blocking)
rofi -show drun -theme "$THEME"
