#!/bin/sh
xrandr -q | sed -rn /\ connected/p | cut -d " " -f1	# doesnt include disconnected 
#xrandr -q | grep connected | cut -d " " -f1		# includes disconnected
