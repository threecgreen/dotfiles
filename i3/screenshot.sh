#!/bin/sh
# Takes a screenshot
scrot $@ '%Y-%m-%d_$wx$h.png' -e 'mv $f ~/pictures/scrots'
