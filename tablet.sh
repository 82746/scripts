#!/bin/zsh

tabletSetup () {
	# get stylus id for xsetwacom commands
	stylus=$(xsetwacom --list devices | sed -rn 's/.*id[^0-9]*([0-9]+).*/\1/p')
	if [[ -z "$stylus" ]] then;
		notify-send -u normal "tablet.sh" "Error: no tablet devices found."
		exit 1
	fi
	# xppen tablet area physical dimensions in mm
	tabletWidth=$((6*25.4))
	tabletHeight=$((4*25.4))
	
	# get full area in wacom units
	xsetwacom set $stylus ResetArea
	xsetwacom set $stylus MapToOutput 1920x1080+1920+0
	fal=$(xsetwacom get $stylus Area | cut -d " " -f 1)
	fat=$(xsetwacom get $stylus Area | cut -d " " -f 2)
	far=$(xsetwacom get $stylus Area | cut -d " " -f 3)
	fab=$(xsetwacom get $stylus Area | cut -d " " -f 4)
	# 1 mm in wacom units (wacom/mm). Calculated using wacom bottom value for full tablet and xppen tablet's height in mm.
	mm=$(($fab / $tabletHeight))
}

setSmallArea () {
	# screen area setting (px)
	screenAreaWidth=1280
	screenAreaHeight=$(($screenAreaWidth*9/16)) 
	# offsets to center area
	offsetx=$((1920 + (1920 - $screenAreaWidth) / 2)) 
	offsety=$(((1080 - $screenAreaHeight) / 2))

	tabletAreaWidth=80
	tabletAreaHeight=$(($tabletAreaWidth * 9/16))
	tabletAreaOffsetX=5
	tabletAreaOffsetY=50
}

setDesktopArea () {
	screenAreaWidth=$((1280 * 1920/1280))
	screenAreaHeight=$(($screenAreaWidth * 9/16)) 

	offsetx=$((1920 + (1920 - $screenAreaWidth) / 2)) 
	offsety=$(((1080 - $screenAreaHeight) / 2))

	tabletAreaWidth=$((80 * 1920/1280))
	tabletAreaHeight=$(($tabletAreaWidth * 9/16))
	tabletAreaOffsetX=$(printf %d $((($tabletWidth - $tabletAreaWidth) / 2)))
	tabletAreaOffsetY=$(printf %d $((($tabletHeight - $tabletAreaHeight) / 2)))
}

setCustomArea () {
	screenAreaWidth=1280
	screenAreaHeight=$(($screenAreaWidth*9/16))

	inputW=$(printf %.1f $(xdg-user-dir SCRIPTS)/dmenu-dialog.sh "width:")
	if [ $inputW -z "" ]; then exit 0; fi

	offsetx=$((1920 + (1920 - $screenAreaWidth) / 2)) 
	offsety=$(((1080 - $screenAreaHeight) / 2))

	tabletAreaWidth=$inputW
	tabletAreaHeight=$(($tabletAreaWidth * 9/16))
	tabletAreaOffsetX=5
	tabletAreaOffsetY=$(($tabletHeight - $tabletAreaHeight - 5)) # (tabletHeight- tabletAreaHeight) gives all the height left outside of area, -5 gives a 5 mm margin.	
}

setRandomArea () {
	screenAreaWidth=1280
	screenAreaHeight=$(($screenAreaWidth*9/16)) 

	randomNum=$(((75 + $RANDOM % 125)*0.01))
	baseW=$((80))

	offsetx=$((1920 + (1920 - $screenAreaWidth) / 2)) 
	offsety=$(((1080 - $screenAreaHeight) / 2))

	tabletAreaWidth=$(printf %.1f $(($baseW*$randomNum)))
	tabletAreaHeight=$(($tabletAreaWidth * 9/16))
	tabletAreaOffsetX=5
	tabletAreaOffsetY=$(($tabletHeight - $tabletAreaHeight - 5)) # (tabletHeight- tabletAreaHeight) gives all the height left outside of area, -5 gives a 5 mm margin.
}

setRelativeMode () {
	# screen area setting (px)
	screenAreaWidth=1000
	#screenAreaHeight=$(($screenAreaWidth*9/16))
	screenAreaHeight=1000 

	#offsetx=$((1920 + (1920 - $screenAreaWidth) / 2)) 
	#offsety=$(((1080 - $screenAreaHeight) / 2))
	offsetx= 0
	offsety= 0

	tabletAreaWidth=160
	tabletAreaHeight=160
	tabletAreaOffsetX=0
	tabletAreaOffsetY=0
}


opt1="small"
opt2="desktop"
opt3="custom"
opt4="random"
opt5="relative mode"

chooseWithDmenu () {
	local choice=$(printf "$opt1\n$opt2\n$opt3\n$opt4\n$opt5" | $(xdg-user-dir SCRIPTS)/dmenu-dialog.sh "profile")

	if [[ "$choice" = "$opt1" ]] then;
		setSmallArea

	elif [[ "$choice" = "$opt2" ]] then;
		setDesktopArea

	elif [[ "$choice" = "$opt3" ]] then;
		setCustomArea

	elif [[ "$choice" = "$opt4" ]] then;
		setRandomArea

	elif [[ "$choice" = "$opt5" ]] then;
		setRelativeMode

	else
		notify-send -u normal "tablet.sh" "Error: invalid profile name. No area set."
		exit 1
	fi

	# send a notification with the tablet area selected
	notify-send -i "input-tablet" -u normal "tablet.sh"  "Tablet area set to $(printf %.4f $tabletAreaWidth) x $(printf %.4f $tabletAreaHeight) (mm); sens: $sens" &

}

chooseWithArg () {
	if [[ "$2" = "$opt1" ]] then;
		setSmallArea

	elif [[ "$2" = "$opt2" ]] then;
		setDesktopArea

	elif [[ "$2" = "$opt3" ]] then;
		setCustomArea

	elif [[ "$2" = "$opt4" ]] then;
		setRandomArea

	elif [[ "$2" = "$opt5" ]] then;
		setRelativeMode

	else
		exit 1
	fi
}

main () {
	if [[ "$1" = "-p" ]] then;
		tabletSetup
		chooseWithArg
	else
		tabletSetup
		chooseWithDmenu
	fi

	# calc a sensitivity kind-of value that represents how fast the cursor moves
	# (how many pixels cursor moves per mm moved on tablet)
	sens=$(($screenAreaWidth / $tabletAreaWidth))

	# calculate wacom area borders
	right=$(printf %i "$((($tabletAreaWidth + $tabletAreaOffsetX) * mm))")
	bottom=$(printf %i "$((($tabletAreaHeight + $tabletAreaOffsetY) * mm))")
	left=$(printf %i "$(($tabletAreaOffsetX * mm))")
	top=$(printf %i "$(($tabletAreaOffsetY * mm))")

	# set wacom area
	xsetwacom set $stylus ResetArea
	xsetwacom set $stylus Area $left $top $right $bottom 
	xsetwacom set $stylus MapToOutput $screenAreaWidth\x$screenAreaHeight+$offsetx+$offsety

	# print the area
	printf "
	WACOM AREA
	left: $left
	rop: $top
	right: $right
	bottom: $bottom

	AREA IN mm
	$tabletAreaWidth x $tabletAreaHeight
	offset x: $tabletAreaOffsetX
	offset y: $tabletAreaOffsetY
	"
}

main
