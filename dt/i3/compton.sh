#! /usr/bin/env bash
# Terminate current polybars
killall -q compton

# Wait until they have been shut down
while pgrep -x compton >/dev/null; do sleep 1; done

# Launch polybar
compton
