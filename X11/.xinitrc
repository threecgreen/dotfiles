#! /bin/bash

# Set keyboard map
setxkbmap -layout us

xrdb -merge ~/.XResources

# Start virtualbox client services
VBoxClient --video
VBoxClient --vmsvga-x11
VBoxClient --clipboard

# Add other resolutions for RDP
xrandr --newmode "1920x1080_60.00"  172.80  1920 2040 2248 2576  1080 1081 1084 1118  -HSync +Vsync
xrandr --addmode Virtual1 "1920x1080_60.00"
xrandr --newmode "2256x1504_60.00"  288.30  2256 2424 2672 3088  1504 1505 1508 1556  -HSync +Vsync
xrandr --addmode Virtual1 "2256x1504_60.00"
# Add proper resolution
xrandr --newmode "2560x1440_60.00"  311.83  2560 2744 3024 3488  1440 1441 1444 1490  -HSync +Vsync
xrandr --addmode Virtual1 "2560x1440_60.00"

xrandr --output Virtual1 --mode '2560x1440_60.00'

# Start i3-gaps
exec i3

