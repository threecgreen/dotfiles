#! /bin/bash

# Set keyboard map
setxkbmap -layout us -variant intl

# Wallpaper
eval `cat ~/.fehbg`

# Start i3-gaps
exec i3
