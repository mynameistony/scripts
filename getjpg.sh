#!/bin/bash

#sub=`matedialog --entry`

user=$USER

getpath=/home/$user/Pictures/Got/get.txt

if [ $# -ne 1 ]
then
	domain=`matedialog --entry`
else
	domain=$1
fi

echo "Sniffing Photos..."

curl www.$domain | grep -o "[A-Za-z0-9]*.com/[A-Za-z0-9]*.jpg" > $getpath

urls=`uniq $getpath`

echo "$urls" > $getpath

count=`grep -c "[A-Za-z0-9]*.jpg" $getpath`

echo "Found $count photos..."

cd /home/$user/Pictures/Got

echo "Downloading photos..."

wget -N -q -i $getpath

matedialog --question

if [ $? -eq 0 ]
then
	eom /home/$user/Pictures/Got/*.jpg
fi
exit 0

