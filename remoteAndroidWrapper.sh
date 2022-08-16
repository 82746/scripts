#!/bin/sh
{
	sndcpy &
}&> /dev/null
sndPID=$!

{
	scrcpy --turn-screen-off --stay-awake --hid-keyboard --max-fps 60 --power-off-on-close --print-fps &
}&> /dev/null
scrPID=$!
#*add redirct to a log file


trap 'cleanup $scrPID $sndPID' SIGINT 

cleanup () {
	PID1=$1
	PID2=$2

	terminate=15 # SIGTERM number, see "kill -l"
	kill -15 $PID1 &> /dev/null
	kill -15 $PID2 &> /dev/null

	exit 0
}

# halt program until scrcpy dies, then quit
wait $scrPID 
cleanup
