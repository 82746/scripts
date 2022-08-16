#!/bin/sh
udevadm control --reload 
pipe=/tmp/usb-udev-pipe
soundThemePath=$(xdg-user-dir)/.local/share/sounds/experimental

[ ! -e "$pipe" ] && mkfifo "$pipe"

while true
do
	msg=$(cat "$pipe")
	echo "$msg"

	if [[ "$msg" == "usb-add" ]]; then
		notify-send -i "usb" -a "udev" "Udev notification" "New USB-device found" &
		mpv --really-quiet $soundThemePath/notifications/device-added.ogg &
	fi

	if [[ "$msg" == "usb-rm" ]]; then
		notify-send -i "usb" -a "udev" "Udev notification" "USB-device removed" &
		mpv --really-quiet $soundThemePath/notifications/device-removed.ogg &
	fi
done
