#!/bin/bash

## Shell-Script to harvest links and titles from subreddits
#
## Author: mynameistony
#
## Usage: reddit.sh [subreddit]
## [subreddit] is optional

# Default File Hierarchy
# 
#/$HOME/Pictures/reddit -> set by $photoDir
#----------------------/data/ 
#----------------------------[subreddit]-links.txt -> contains links for each [subreddit]
#----------------------------[subreddit]-titles.txt -> contains titles for each [subreddit]
#--------------------------------------
#----------------------/[subreddit]/ -> contains files downloaded from links (can be moved to a different location before download)
#-----------------------------------[content]
#-----------------------------------[content]
#-----------------------------------[content]
#
#
#
#


######If subreddit is not passed via arg then prompt######
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

######Some variables for ease######
photoDir="$HOME/Pictures/reddit"
titles="$photoDir/data/$sub-titles.txt"
urls="$photoDir/data/$sub-urls.txt"

######Check for reddit folder######
test -e $photoDir
if [ $? -ne 0 ]
then
	mkdir -p "$photoDir/data"
fi

######Check for subreddit folder######
test -e "$photoDir/$sub"

if [ $? -ne 0 ]
then
	mkdir $photoDir/$sub
fi

######Get JSON page -> parse for titles -> add to titles file######
echo -n "Getting titles..."

curl -s --no-keepalive -A "Mozilla" "http://www.reddit.com/r/$sub.json" | grep -o "\"title\": \"[-A-Za-z0-9 \"#/\!?()_,'.\[*\]*]*" | sed s/"\"title\": "/""/ | sed s/", \"created_utc\""/""/ > "$titles"

if [ $? -ne 0 ]
then
	echo "Couldn't get Titles"
	exit 0
fi
titleCount=`cat $titles | wc -l`
echo "Found $titleCount titles."

######Get JSON page -> parse for links -> add to links file######
echo -n "Getting links..."
curl -s --no-keepalive -A "Mozilla" "http://www.reddit.com/r/$sub.json" | grep "\"url\": \"[-A-Za-z0-9 %:\"#/\!?()_'.\[*\]*]*" -o  | grep "http://[A-Za-z0-9./_]*" -o > "$urls"
if [ $? -ne 0 ]
then
	echo "Couldn't get links"
	exit 0
fi
linkCount=`cat $urls | wc -l`
echo "Found $linkCount links."

###### View Titles?######
echo -n "View titles? "
read prompt
if [ $prompt == "y" ]
then
	cat "$titles"
fi

###### View URLS?######
echo -n "View URLs? "
read prompt
if [ $prompt == "y" ]
then
	cat "$urls"
fi

######Download files?######
echo -n "Download $linkCount links? "
read prompt
if [ $prompt == "y" ]
then

	######Download to location?######
	echo "Downloading to: $photoDir/$sub"
	echo -n "Download to a different folder? "
	read prompt
	if [ $prompt == "y" ]
	then
		echo -n "Download to: $HOME/"
		read newDir
		
		thisDir="$HOME/$newDir"
		test -e "$thisDir"
		if [ $? -ne 0 ]
		then
			echo "Creating folder $thisDir"
			mkdir -p "$thisDir"
		fi

			
	else
		thisDir="$photoDir/$sub"
	fi

	cd "$thisDir"
	echo -n "Downloading links..."
	wget -q -N -i "$urls"
	echo "Downloaded $linkCount files to $thisDir"

	######View downloaded files?######
	echo -n "View downloaded files? "
	read prompt
	if [ $prompt == "y" ]
	then
		#This is the image viewer for MATE, change accordingly
		eom *
	fi
fi

echo "Thanks Bye!"
exit 0
