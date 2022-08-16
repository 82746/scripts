#!/bin/sh

focus=$(xdotool getactivewindow)
# focus to root window to make cursor available.
xdotool windowfocus root

# cache screenshot
cacheFile=$HOME/.cache/screenshot
maim -sq -b 100000 -c 0,0,0,0.85 | cat > $HOME/.cache/screenshot

# check if a screenshot was taken and proceed
if [[ -n $(cat $cacheFile | tr '\0' '\n') ]]; then
	option1="Copy to clipboard"
	option2="Save as a file"
	
	choice=$(printf "$option1\n$option2" | $(xdg-user-dir SCRIPTS)/dmenu-dialog.sh)
	
	filename=$(date +"%d.%m.%Y_%H:%M:%S").png
	
	if [ "$choice" == "$option1" ]; then
		cat $cacheFile | xclip -selection clipboard -t image/png
		notify-send -i "edit-copy" -u normal "Screenshot copied to clipboard." &

	elif [ "$choice" == "$option2" ]; then
		# check if screenshot folder exists and save, if not save to home dir
		if [ -e $(xdg-user-dir PICTURES)/Screenshots ]; then
			cat $cacheFile > $(xdg-user-dir PICTURES)/Screenshots/$filename
		else
			cat $cacheFile > $HOME/$filename
		fi

		# check if screenshot got saved properly
		if [[ -n $(cat $(xdg-user-dir PICTURES)/Screenshots/$filename | tr '\0' '\n') ]]; then
			notify-send -i "filesave" -u normal "Screenshot saved as '$filename'" &
		else 
			notify-send -i "cancel" -u normal "Failed to save screenshot." &
		fi
	else
		notify-send -i "cancel" -u normal "Screenshot canceled." &
	fi

else
	notify-send -i "cancel" -u normal "Screenshot canceled." &
fi

# delete cache file
[ -e "$cacheFile" ] && rm $cacheFile

# return focus to original window
xdotool windowfocus $focus

exit 0
