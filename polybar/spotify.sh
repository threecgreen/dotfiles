#! /usr/bin/env bash
# Capture both stderr and stdout
status=$(playerctl status -p spotify 2>&1)
if [[ "$status" == "Playing" ]]; then
    title=`exec playerctl -p spotify metadata xesam:title`
    artist=`exec playerctl -p spotify metadata xesam:artist`
    echo "$title | $artist"
else
    echo ""
fi
