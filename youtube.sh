#!/bin/bash

cd "$HOME/Music/"

if [ $# -lt 1 ]
then
	echo -e "Usage: youtube.sh [-u]|[-f] [url-hash]|[file-of-url-hashes]\n"
	echo -e "Examples:"
	echo -e "\tyoutube.sh -u MZoO8QVMxkk"
	echo -e "\nor\n"
	echo -e "\tyoutube.sh -f /path/to/file"

	url="$(matedialog --entry --text="Paste URL" | grep "[-_A-Za-z0-9]*$" -o)"
	format="$(matedialog --column=Choose --radiolist --column=Color why Audio-Only the Standard-Video fuck HD-Video --list)"
	
	message="Downloading 'www.youtube.com/watch?v=$url' as $format"
	echo $message
	notify-send "$message"

	if [ $format == "Audio-Only" ]
	then	
		cd "$HOME/Music/Youtube"
		fcode="140"
	elif [ $format == "Standard-Video" ]
	then

		cd "$HOME/Videos/Youtube"
		fcode="18"
	elif [ $format == "HD-Video" ]
	then
		cd "$HOME/Videos/Youtube"
		fcode="22"
	else
		notify-send "Shits Fucked Yo"
		exit 1
	fi

	notify-send "Starting download...be very patient"
	
	youtube-dl -f "$fcode" "https://www.youtube.com/watch?v=$url" | tee youtube-download.log  
	
	info="$(tail ./youtube-download.log)"
	notify-send "$info"


	exit 0
fi

if [ "$1" == "-u" ]
then
	if [ "$2" == "" ]
	then
		echo "No URL"
		exit 0
	fi


	youtube-dl -f 140 "https://www.youtube.com/watch?v=$2"

#	output="$(youtube-dl -F "$2")"

#	audio_output="$(echo "$output" | grep "audio")"

#	audio_code="$(echo "$audio_output" | grep "^[0-9][0-9][0-9]" -o)"https://www.youtube.com/watch?v=MZoO8QVMxkk


	exit 0
elif [ "$1" == "-f" ]
then
	if [ "$2" == "" ]
	then
		echo "No Input file"
		exit 0
	fi
	
	for url in "$2"
	do
		output="$(youtube-dl -F "https://www.youtube.com/watch?v=$url")"

		audio_output="$(echo "$output" | grep "audio")"

		audio_code="$(echo "$audio_output" | grep "^[0-9][0-9][0-9]" -o)"

		youtube-dl -f "$audio_code" "https://www.youtube.com/watch?v=$url"
	done	
	
	exit 0
fi
		






