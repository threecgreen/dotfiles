#! /bin/bash

# Set keyboard map
setxkbmap -layout us

xrdb -merge ~/.XResources

# Start virtualbox client services
VBoxClient --video
VBoxClient --vmsvga-x11
VBoxClient --clipboard

# Add proper resolution
xrandr --newmode "2560x1440_60.00"  311.83  2560 2744 3024 3488  1440 1441 1444 1490  -HSync +Vsync
xrandr --addmode Virtual-1 "2560x1440_60.00"

xrandr --output Virtual-1 --mode '2560x1440_60.00'

# Start i3-gaps
exec i3

