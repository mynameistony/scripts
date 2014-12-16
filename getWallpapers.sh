#!/bin/bash

curl -s www.reddit.com/r/wallpapers.json | grep -o "http://i.imgur.com/[A-Za-z0-9]*.jpg" > /home/tony/Pictures/Wallpapers/wallpapers.txt

cd /home/tony/Pictures/Wallpapers

wget -N -q -i /home/tony/Pictures/Wallpapers/wallpapers.txt
