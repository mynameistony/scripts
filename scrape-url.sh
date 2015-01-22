#!/bin/bash
URL_REGEX="http://[A-Za-z0-9.]*.com/[-_%A-Za-z0-9/.]*"

TOP_DIR="$HOME/url-scrape"
URL_COMP_FILE="$TOP_DIR/url-compilation.txt"
THIS_URL_FILE="$TOP_DIR/foundurls.txt"

function parse_urls(){
	if [ $1 == "" ]
	then
		echo "No URL"
		return
	fi

	echo -n "Scanning $1 ..."

	DOMAIN="$(echo $1 | grep "[a-z]*.com" -o | sed s/\.com//)"

	test -e "$TOP_DIR/$DOMAIN"
	if [ $? -ne 0 ]
	then
		mkdir -p $TOP_DIR/$DOMAIN
	fi
		
	curl $1 -s |  grep "$URL_REGEX" -o | sort | uniq > "$TOP_DIR/$DOMAIN/urls.tmp"

	echo "Done"
	
	cat "$TOP_DIR/$DOMAIN/urls.tmp" | grep ".[jgp][pin][gf]$" | sort | uniq >> $TOP_DIR/$DOMAIN/images.txt

	cat "$TOP_DIR/$DOMAIN/urls.tmp" | grep "\.[a-z]*$" | sort | uniq >> $TOP_DIR/$DOMAIN/files.txt

	cat "$TOP_DIR/$DOMAIN/urls.tmp" | grep "\.[a-z]*$" -v | sort | uniq >> $TOP_DIR/$DOMAIN/urls.txt

	sort $TOP_DIR/$DOMAIN/images.txt | uniq > $TOP_DIR/$DOMAIN/images.sorted

	sort $TOP_DIR/$DOMAIN/files.txt | uniq > $TOP_DIR/$DOMAIN/files.sorted

	sort $TOP_DIR/$DOMAIN/urls.txt | uniq > $TOP_DIR/$DOMAIN/urls.sorted

	echo "Found $(cat $TOP_DIR/$DOMAIN/images.sorted | wc -l) images in $1"

	echo "Found $(cat $TOP_DIR/$DOMAIN/urls.sorted | wc -l) urls in $1"

	parse_urls_from_file "$TOP_DIR/$DOMAIN/urls.sorted"

}

function parse_urls_from_file(){

	for url in $(cat $1)
	do
		parse_urls "$url"
	done

}

test -e "$TOP_DIR"
if [ $? -ne 0 ]
then
	echo "Creating url-scrape folder in home directory"
	mkdir "$TOP_DIR"
fi

cd "$TOP_DIR"

if [ $# -eq 1 ]
then

	parse_urls $1

else
	echo "Need a starting URL..."
fi
