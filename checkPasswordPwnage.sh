#!/bin/sh

check_password() {
	local passwHash=$(printf $1 | sha1sum | sed -nr 's/([a-z0-9]*).*/\1/p' | tr 'a-z' 'A-Z')
	local hashPrefix=$(echo $passwHash | sed -nr 's/^(.{5}).*/\1/p') # first 5 chars of hash to be sent to the api
	local hashSuffix=$(echo $passwHash | sed -nr 's/^.{5}(.*)/\1/p') # first 5 chars of hash to be sent to the api

	local response=$(curl -s https://api.pwnedpasswords.com/range/$hashPrefix)
	local occurences=0
	
	IFS=$'\n'
	for line in $response
	do
		local respHash=$(echo $line | cut -d":" -f1)
		printf "$hashSuffix\n$respHash\n\n"
	
		if [[ $respHash == $hashSuffix ]]; then
			local occurences=$(printf $line | sed -nr 's/.*\:([0-9]+).*/\1/p')
			break
		fi
	done
	
	if [[ $occurences -eq 0 ]]; then
		printf "Good\nPassword not found in any leaks\n"
	else
		printf "Warning\nPassword found in $occurences leaks.\n"
	fi
	printf "Source: haveibeenpwned.com\n"
}

check_email() {
	echo not implemented yet
}

helpmessage='Usage: pwnage {[-p --password] <password>, [-e --email] <email>}\n'

if ! [[ "$2" =~ [^\ .]+ ]]; then
	printf "$helpmessage"
	exit 1
fi

option=$1

if [[ "$option" == "--password" ]]; then
	check_password $2

elif [[ "$option" == "--email" ]]; then
	check_email $2
fi
