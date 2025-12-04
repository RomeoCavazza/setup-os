#!/usr/bin/env bash

# Available Styles
# blurry	blurry_full		kde_simplemenu		kde_krunner		launchpad
# gnome_do	slingshot		appdrawer			appdrawer_alt	appfolder
# column	row				row_center			screen			row_dock		row_dropdown

theme="column-tco"
dir="$HOME/.config/rofi/custom/"

# comment these lines to disable random style
# themes=($(ls -p --hide="launcher.sh" $dir))
# theme="${themes[$(( $RANDOM % 16 ))]}"

rofi -no-lazy-grab -show drun -modi drun -theme $dir/"$theme"
