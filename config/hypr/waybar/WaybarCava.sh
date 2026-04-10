#!/usr/bin/env bash

# Not my own work. Credit to original author
# ----- Optimized bars animation without much CPU usage increase --------

bar="▁▂▃▄▅▆▇█"
dict="s/;//g"

bar_length=${#bar}
for ((i = 0; i < bar_length; i++)); do
    dict+=";s/$i/${bar:$i:1}/g"
done

config_file="/tmp/bar_cava_config"
cat >"$config_file" <<'EOF'
[general]
framerate = 60
bars = 14

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

pkill -f "cava -p $config_file" 2>/dev/null || true

# Convert digits to bars then hide "silence" (only ▁)
cava -p "$config_file" \
  | sed -u "$dict" \
  | awk '
      BEGIN { silent = "^▁+$" }
      $0 ~ silent { print ""; fflush(); next }
      { print; fflush() }
    '
