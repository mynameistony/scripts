#!/bin/bash

SCRAPE_DIR="$HOME/wiki/"
mkdir -p $SCRAPE_DIR/archives
touch $SCRAPE_DIR/archived
touch $SCRAPE_DIR/unarchived

cd $SCRAPE_DIR

function getLinks(){

	if [ $# -ne 1 ]
		then
		echo "[$0]>[getLinks] Expects 1 url, got $#"
		exit 1
	else
		exists=$(cat archived | grep $1 | wc -l)

		if [ $exists == 0 ]
			then
			touch archives/$1.html
			newLinks=$(curl -s -A Mozilla  http://en.wikipedia.org/wiki/$1 | hxselect p | tee archives/$1.html | grep " <a href=\"[-A-Za-z0-9 _/]*\" " -o | grep "/wiki/.*" -o | sed s/"\" $"//g | sed s/"^\/wiki\/"//g)	
			echo $newLinks | sed s/$1//g >> unarchived
			echo $1 >> archived
		else
			echo "$1 exists, and was not archived" >> /dev/stderr
		fi
	fi
}

function pullUnarchived(){
	links=$(cat unarchived)
	for link in $(echo $links)
	do
		getLinks $link
	done
}


if [ "$1" == "-p" ]
	then
	pullUnarchived
else
	getLinks $1
fi