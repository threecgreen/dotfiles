#!/bin/sh
default_sink="$(pactl info | sed -En 's/Default Sink: (.*)/\1/p')"
case "$default_sink"  in
    *USB* ) echo -e "speakers \UE32D";;
    *4.analog-stereo ) echo "headphones ";;
    * ) echo "unknown";;
esac

