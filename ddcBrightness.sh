#!/bin/sh

cacheFolder="$HOME/.cache/ddcBrightness"
cacheFile="$cacheFolder/brightness"

setupCache () {
	if ! [ -a "$cacheFolder" ]
	then
		echo "Creating cache directory $cacheFolder"
		mkdir -p "$cacheFolder"
	fi
	
	if ! [ -a "$cacheFile" ]
	then
		echo "Creating brightness cache file. $cacheFile"
		touch "$cacheFile"
		echo $(ddcutil -d $disp getvcp 10 | sed -rn 's/.*current[^0-9]*([0-9]{1,3}).*/\1/p') > $cacheFile
	fi
	
	if [[ ! "$(cat $cacheFile)" =~ ^[0-9]{1,3} ]]	# if wrong format(letters used, no value,..), cache new value
	then
		echo "resetting cache file (invalid value)."
		echo $(ddcutil -d $disp getvcp 10 | sed -rn 's/.*current[^0-9]*([0-9]{1,3}).*/\1/p') > $cacheFile
	
	
	elif [ $(cat $cacheFile) -ge 101 ]	# if brightness too high
	then
		echo "resetting cache file (invalid value)."
		echo $(ddcutil -d $disp getvcp 10 | sed -rn 's/.*current[^0-9]*([0-9]{1,3}).*/\1/p') > $cacheFile
	fi
}

# main program

setupCache
brightness=$(cat $cacheFile)
disp=1

if ! [[ "$2" =~ [0-9]+ ]] && [[ $1 != "" ]]
then
	echo "argument must be a number"
	exit 1
fi

if [ "$1" == "-bu" ]
then
	if [ $(($brightness + $2)) -ge 100 ]
	then
		brightness=100
	else
		brightness=$(($brightness+$2))
	fi

	brightness=$(($brightness))
	ddcutil -d $disp setvcp 10 $(($brightness))
	echo $(($brightness)) > $cacheFile
	exit 1
fi

if [ "$1" == "-bd" ]
then
	if [ $(($brightness - $2)) -le 0 ]
	then
		brightness=1
	else
		brightness=$(($brightness-$2))
	fi

	ddcutil -d $disp setvcp 10 $(($brightness))
	echo $(($brightness)) > $cacheFile
	exit 1
fi

if [ "$1" == "blue" ]
then
	if [ $2 -ge 0 ] && [ $2 -le 100 ]
	then
		ddcutil -d $disp setvcp 1a $2
	else
		echo "invalid value. has to be [0-100]"
	fi
	exit 1
fi

printf "Usage: [COMMAND] [ARGUMENT([0-9]+)]\nCommands: lower, raise\n"
exit 1












