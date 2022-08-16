#!/bin/sh

#
# Running pactl commands through this script will update polybar mic module's appearance.
#

if [[ "$1" == "up" ]]; then
	pactl set-source-volume @DEFAULT_SOURCE@ +2%
fi

if [[ "$1" == "down" ]]; then
	pactl set-source-volume @DEFAULT_SOURCE@ -2%
fi

if [[ "$1" == "unmute" ]]; then
	pactl set-source-mute @DEFAULT_SOURCE@ 0
fi

if [[ "$1" == "mute" ]]; then
	pactl set-source-mute @DEFAULT_SOURCE@ 1
fi

if [[ "$1" == "togglemute" ]]; then
	pactl set-source-mute @DEFAULT_SOURCE@ toggle
fi

pipe=$(xdg-user-dir)/.cache/mic-pipe
if [[ -p $(xdg-user-dir)/.cache/mic-pipe ]]; then
	echo "update" > $pipe &
fi
