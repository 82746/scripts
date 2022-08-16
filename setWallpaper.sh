#!/bin/sh
killall -15 xwinwrap &> /dev/null

wpPath=$HOME/.wallpaper
fileMime=$(file --brief --mime $wpPath | sed -nr 's/(^[a-z0-9\/]+);.*/\1/p')
fileType=$(echo $fileMime | cut -d"/" -f1)
fileExtension=$(echo $fileMime | cut -d"/" -f2)

[[ "$fileType" != "image" ]] && [[ "$fileType" != "video" ]] && exit 1

if [[ $fileExtension == "gif" ]] || [[ $fileExtension == "mp4" ]]; then
	for res in $($(xdg-user-dir SCRIPTS)/getResos.sh)
	do 
		echo $res
		xwinwrap -debug -g $res -un -fdt -ni -b -nf -ov -- $(xdg-user-dir SCRIPTS)/mpv-wallpaper.sh %WID $wpPath &
	done
fi

[[ "$fileType" != "image" ]] && exit 0

#wal -n -q -i $wpPath &
feh --no-fehbg --bg-fill --geometry +0+0 $wpPath &
