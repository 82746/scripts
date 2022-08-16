#!/bin/sh

filename="tempfile"
size=1024

# check if file already exists
if [ -a $filename ]
then
	echo "A file named '$filename' already exists."
	exit 1
fi

# WRITE speed test
printf "Write:\n"
dd if=/dev/zero of=$filename bs=1M count=$size

# READ speed test
printf "\nRead:\n"
dd if=$filename of=/dev/null bs=1M count=$size

# remove temporary file
filecontent=$(echo $(cat $filename | echo))

# make sure file is empty
if [ -z "$filecontent" ]
then
	rm $filename
else
	echo "Could not remove temporary file '$filename', as it appears to not be empty."
	exit 1
fi
