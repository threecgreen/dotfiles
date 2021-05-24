#!/bin/sh
default_sink="$(pactl info | sed -En 's/Default Sink: (.*)/\1/p')"
case "$default_sink" in
    *USB* ) pactl set-default-sink alsa_output.pci-0000_0e_00.4.analog-stereo;;
    *4.analog-stereo ) pactl set-default-sink alsa_output.usb-Burr-Brown_from_TI_USB_Audio_DAC-00.analog-stereo;;
    * ) ;;
esac
