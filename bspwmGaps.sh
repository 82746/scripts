#!/bin/sh
mode=$1

deskFocus=$(bspc query --desktops --desktop focused)
currPad=$(bspc config -d $deskFocus bottom_padding) 	# currPad = gap size, relative to which changes are made. Taken from bottom.
#top_offset=$((5*6))	# how much larger the top padding is
increment=12	
min=0		# smallest window gap allowed
max=500		# largest window gap allowed

if [ $mode == "+" ]; then
	if [ $currPad -le $(($max - $increment)) ]; then
		bspc config -d $deskFocus top_padding $(($currPad+$increment))
		bspc config -d $deskFocus right_padding $(($currPad+$increment))
		bspc config -d $deskFocus left_padding $(($currPad+$increment))
		bspc config -d $deskFocus bottom_padding $(($currPad+$increment))
	fi
else
	if [ $currPad -ge $(($min + $increment)) ]; then
		bspc config -d $deskFocus top_padding $(($currPad-$increment))
		bspc config -d $deskFocus right_padding $(($currPad-$increment))
		bspc config -d $deskFocus left_padding $(($currPad-$increment))
		bspc config -d $deskFocus bottom_padding $(($currPad-$increment))
	fi
fi
