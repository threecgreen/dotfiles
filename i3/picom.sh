#! /usr/bin/env bash
# Terminate current polybars
killall -q picom

# Wait until they have been shut down
while pgrep -x picom >/dev/null; do sleep 1; done

# Launch polybar
picom
