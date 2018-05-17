#!/usr/bin/env bash
if [ "$1" == "aur" ]; then
    checkupdates-aur | wc -l
else
    checkupdates | wc -l
fi
