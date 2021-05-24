#! /bin/bash

# Set keyboard map
setxkbmap -layout us
# Xresources
xrdb -merge "$HOME/.Xresources"

xrandr --output DisplayPort-0 --pos 0x0 --scale 1x1 --output HDMI-A-0 --right-of DisplayPort-0 --scale 1x1

# Wallpaper
eval "$HOME/.fehbg"

# Start i3-gaps
exec i3 >> ~/.cache/i3.log 2>&1

# Start Awesome WM
# awesome

