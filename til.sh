#!/bin/bash

curl -s http://www.reddit.com/r/todayilearned/|perl -ne 'while (m/<a class="title[^>]*>([^<]*)/g) { print "$1\n"};' >> facts.txt

facts=`cat facts.txt`

notify-send "$facts"
