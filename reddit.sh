#!/bin/bash

sub=`matedialog --entry`

curl -s www.reddit.com/r/$sub.json | grep -o "http://i.imgur.com/[A-Za-z0-9]*.jpg" > /home/tony/Pictures/Reddit/get.txt

cd /home/tony/Pictures/Reddit

wget -N -q -i /home/tony/Pictures/Reddit/get.txt
