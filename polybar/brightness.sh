#! /usr/bin/env bash
# No STDERR
exec 2> /dev/null
# Get current backlight percentage
brightness=`light -G | cut -d '.' -f 1`
echo "$brightness%"
