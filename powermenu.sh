#!/bin/zsh
confirm() {
	local action=$1

	confirm_choice=$(printf "no\nyes" | $(xdg-user-dir SCRIPTS)/dmenu-dialog.sh "Confirm?")

	if [[ "$confirm_choice" == "yes" ]]; then

		if [[ "$choice" == "$opt1" ]]; then
			$(xdg-user-dir SCRIPTS)/shutdown.sh
		
		elif [[ "$choice" == "$opt2" ]]; then
			reboot
		
		elif [[ "$choice" == "$opt3" ]]; then
			systemctl suspend		
		
		elif [[ "$choice" == "$opt4" ]]; then
			exec $(xdg-user-dir SCRIPTS)/lockscreen.sh
		
		elif [[ "$choice" == "$opt5" ]]; then
			loginctl terminate-session ${XDG_SESSION_ID-}	
		fi
	else
		exit 0
	fi
}
# use a nerdfonts patched font for correct symbols
opt1="襤 Shut down"
opt2="累 Reboot"
opt3="鈴 Suspend"
opt4=" Lock screen"
opt5="﫼 Log out"

choice=$(echo "$opt1\n$opt2\n$opt3\n$opt4\n$opt5" | sh $(xdg-user-dir SCRIPTS)/dmenu-dialog.sh "pwr")

[[ $choice != "" ]] && confirm $choice
exit 0
