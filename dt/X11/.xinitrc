#! /bin/bash

# Set keyboard map
setxkbmap -layout us

xrandr --output DP-0 --pos 0x0 --output HDMI-0 --pos 1920x0

# Wallpaper
eval `~/.fehbg`

# Start i3-gaps
exec i3
