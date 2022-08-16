#!/bin/sh
pipe=$(xdg-user-dir)/.cache/mic-pipe

[ ! -e "$pipe" ] && mkfifo "$pipe"

while true
do
	vol=$(pactl get-source-volume @DEFAULT_SOURCE@ | sed -rn 's/.*\/\ *([0-9]+)%.*/\1/p')
	mute=$(pactl get-source-mute @DEFAULT_SOURCE@ | cut -d" " -f2)

	if [[ "$mute" == "no" ]]; then
		echo " $vol%"
	else
		echo " $vol%"
	fi

	msg=$(cat "$pipe") # halt until changes in pipe
	# continue
done

