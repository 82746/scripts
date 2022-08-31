#!/bin/sh

options=()
passw=""

check_password() {
	# go through options
	local quiet=0
	local numonly=0

	IFS=$'-'
	for i in "${options[@]}"
	do
		if [[ "$i" =~ q$ ]] || [[ "$i" =~ quiet$ ]]; then
			quiet=1
		elif [[ "$i" =~ n$ ]] || [[ "$i" =~ numonly$ ]]; then
			numonly=1
		fi
	done

	# do the password checking
	local passwHash=$(printf "$passw" | sha1sum | sed -nr 's/([a-z0-9]*).*/\1/p' | tr 'a-z' 'A-Z')
	local hashPrefix=$(echo $passwHash | sed -nr 's/^(.{5}).*/\1/p') # first 5 chars of hash to be sent to the api
	local hashSuffix=$(echo $passwHash | sed -nr 's/^.{5}(.*)/\1/p') # remaining 5 chars of hash

	local response=$(curl -s https://api.pwnedpasswords.com/range/$hashPrefix)
	local occurences=0
	

	# hash comparison loop
	IFS=$'\n'
	if [[ "$quiet" == "1" ]]; then
		for line in $response
		do
			local respHash=$(echo $line | cut -d":" -f1)
		
			if [[ $respHash == $hashSuffix ]]; then
				local occurences=$(printf $line | sed -nr 's/.*\:([0-9]+).*/\1/p')
				break
			fi
		done
	else
		clear
		sleep 0.1
		for line in $response
		do
			local respHash=$(echo $line | cut -d":" -f1)
			clear
			printf "$hashSuffix\n$respHash\n"
		
			if [[ $respHash == $hashSuffix ]]; then
				local occurences=$(printf $line | sed -nr 's/.*\:([0-9]+).*/\1/p')
				break
			fi
		done
	fi

	
	if [[ "$numonly" == "1" ]]; then
		printf "$occurences\n"
		exit 0
	fi

	if [[ $occurences -eq 0 ]]; then
		clear
		printf "Good\nPassword not found in any leaks\n"
	else
		printf "Warning\nPassword found in $occurences leaks.\n"
	fi
	printf "Source: haveibeenpwned.com\n"
}

helpmessage="usage: pwnage [options] <password>\n\t-q, --quiet\n\t\tdon\'t print hash comparisons\n\t-n, --numonly\n\t\tdon\'t print the result message\n"

# gather all valid options and find password argument
for i in $@
do
	if [[ "$i" =~ ^\-(q|\-quiet|n|\-numonly)$ ]]; then
		options+=($i)

	# if argument structured like an option but isnt valid, exit
	elif [[ "$i" =~ \-.* ]]; then
		printf "invalid option $i\n\n"
		printf "$helpmessage"
		exit 1

	# set password as last non-option-like argument
	elif [[ "$i" =~ [^\ .]+ ]]; then
		passw=$i
		break
	fi
done

# pring help message if no arguments or password given
if ! [[ "$@" =~ [^\ .]+ ]]; then
	printf "$helpmessage"
	exit 1
fi
if [[ "$passw" == "" ]]; then
	printf "$helpmessage"
	exit 1
fi

check_password "${options[@]}"
