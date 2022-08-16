#!/bin/sh

# used by a udev rule to transmit usb events to a named pipe other scripts can read from

if [[ -p /tmp/usb-udev-pipe ]]; then
	su sus -c 'echo '$1' > /tmp/usb-udev-pipe' &
fi
