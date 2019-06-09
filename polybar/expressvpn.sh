#! /usr/bin/bash
# Store first word in first line and remove character formatting
fw=$(expressvpn status | head -n 1 | cut -d' ' -f 1 | sed -r 's/\x1B\[[0-9;]+m//g')
# Not connected
if [[ "$fw" == "Reconnecting" ]]; then
    echo "reconnecting…"
elif [[ "$fw" == "Connected" ]]; then
    # Is connected, print server location
    echo $(expressvpn status | head -n 1 | cut -d' ' -f 3-)
else
    echo "not connected"
fi
