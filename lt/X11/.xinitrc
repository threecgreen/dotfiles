#! /bin/bash

# Set keyboard map
setxkbmap -layout us

# Configure touchpad
synclient PalmDetect=1
synclient PalmMinZ=100
synclient PalmMinWidth=8
synclient VertScrollDelta=-95
synclient HorizScrollDelta=-95
synclient TapButton1=1
synclient TapButton2=3

# Wallpaper
eval `~/.fehbg`

# Start i3-gaps
exec i3
