#!/usr/bin/env bash
# Ignore stderr
exec 2> /dev/null
if [ "$1" == "aur" ]; then
    checkupdates-aur | wc -l
else
    checkupdates | wc -l
fi
