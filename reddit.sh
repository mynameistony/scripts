#!/bin/bash

# If subreddit is not passed via arg then prompt
if [ $# -eq 1 ]
then
	sub=$1
else
	echo -n "Enter subreddit: "
	read sub	

	#This is a simple GUI for entering a subreddit for the MATE Desktop environment
	#
	#sub=`matedialog --entry --text="Enter Subreddit"`
fi

# Some variables for ease

photoDir="/home/$USER/Pictures/reddit"
titles="$photoDir/$sub/titles.txt"
links="$photoDir/$sub/links.txt"

# Check for reddit folder
test -e $photoDir
if [ $? -ne 0 ]
then
	mkdir "$photoDir"
fi

# Check for subreddit folder
test -e "$photoDir/$sub"

if [ $? -ne 0 ]
then
	mkdir $photoDir/$sub
fi


# Get JSON page -> parse for titles -> add to titles file
echo -n "Getting titles..."

curl -s --no-keepalive -A "Mozilla" "http://www.reddit.com/r/$sub.json" | grep -o "\"title\": \"[-A-Za-z0-9 \"#/\!?()_,'.\[*\]*]*" | sed s/"\"title\": "/""/ | sed s/", \"created_utc\""/""/ > "$titles"

if [ $? -ne 0 ]
then
	echo "Couldn't get Titles"
	exit 0
fi
echo "Done"

# Get JSON page -> parse for links -> add to links file
echo -n "Getting links..."
curl -s --no-keepalive -A "Mozilla" "http://www.reddit.com/r/$sub.json" | grep "\"url\": \"[-A-Za-z0-9 %:\"#/\!?()_'.\[*\]*]*" -o  | grep "http://[A-Za-z0-9./_]*" -o> "$links"

if [ $? -ne 0 ]
then
	echo "Couldn't get links"
	exit 0
fi
echo "Done"

# Print stats
echo -n "Titles: "
cat $titles | wc -l
echo -n "Links: "
cat $links | wc -l

cd $photoDir/$sub

echo -n "Downloading links..."
wget -q -N -i "$links"
echo "Done"

echo "View Links? "
read prompt

if [ $prompt == "y" ]
then
	#This is the image viewer for MATE, 
	#Change accordingly
	eom *
fi

exit 0
