#! /usr/bin/env bash
# Make spotify the active window (used for keyboard shortcut)
id="$(wmctrl -lx | grep spotify | cut -d' ' -f1)"
wmctrl -ia $id
