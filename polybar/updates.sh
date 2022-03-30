#!/usr/bin/env bash
# Ignore stderr
exec 2> /dev/null
if [ "$1" == "aur" ]; then
    paru -Sya $> /dev/null
    paru -Qua | wc -l
else
    checkupdates | wc -l
fi
