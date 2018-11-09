#! /bin/bash

# Set keyboard map
setxkbmap -layout us

xrandr --output VGA-1 --mode 2560x1440

VBoxClient --clipboard

# Start i3-gaps
exec i3

