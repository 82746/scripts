#!/bin/sh
action=$1
direction=$2 # west, east, north, south

if [ "$action" != "s" ] && [ "$(bspc query --nodes --node $direction)" == "" ] && [ "$(bspc query --desktops --desktop $direction:focused)" != "" ]
then
	bspc desktop -$action $direction:focused
	xdotool mousemove --screen $(bspc query --monitors --monitor focused) --polar 100 100

#### move node to another monitor with shift h/l ####
#elif [ "$action" == "s" ] && [ "$(bspc query --nodes --node $direction)" == "" ]
#then
#	bspc node --to-desktop $(bspc query --desktops --desktop $direction:focused)	

else
	bspc node -$action $direction
	xdotool mousemove --window $(bspc query --nodes --node focused) 20 20
fi



