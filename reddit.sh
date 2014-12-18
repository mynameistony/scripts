#!/bin/bash

photoDir="/home/$USER/Pictures/Reddit"

if [ $# -eq 1 ]
then
	sub=$1
else
	sub=`matedialog --entry`
fi


test -e $photoDir

if [ $? -ne 0 ]
then
	mkdir "$photoDir"
fi


test -e "$photoDir/$sub"

if [ $? -ne 0 ]
then
	mkdir $photoDir/$sub
fi

titles="$photoDir/$sub/titles.txt"
links="$photoDir/$sub/links.txt"

echo -n "Getting titles..."
curl -s --no-keepalive -A "Mozilla" "http://www.reddit.com/r/$sub.json" | grep "\"title\": \"[-A-Za-z0-9 \"#/\!?()_,'.\[*\]*]*" -o > "$titles"
echo "Done[$?]"

echo -n "Getting links..."
curl -s --no-keepalive -A "Mozilla" "http://www.reddit.com/r/$sub.json" | grep "\"url\": \"[-A-Za-z0-9 %:\"#/\!?()_'.\[*\]*]*" -o > "$links"
echo "Done[$?]"

echo -n "Titles: "
cat $titles | wc -l

echo -n "Links: "
cat $links | wc -l

sed s/"\"title\": "/""/ "$titles" | sed s/", \"created_utc\""/""/ | sed s/"\s"/""/ | sed s/"\s"/""/ | sed s/"\s"/""/ > $titles.tmp

cat "$titles.tmp" > "$titles"

grep "http://[A-Za-z0-9./_]*" $links -o > $links.tmp

cat $links.tmp > $links

rm $photoDir/$sub/*.tmp

cd $photoDir/$sub

echo -n "Downloading links..."
wget -q -N -i "$links"
echo "Done"

echo "View Links? "
read prompt

if [ $prompt == "y" ]
then
	eom *
fi

#for title in `cat "$titles"`
#do
#	for link in `cat "$links"`
#	do
#		echo "Title: "
#		echo "$title"
#		echo "Link: "
#		echo "$link"
#	done
#done

exit 0
