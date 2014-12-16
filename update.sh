#!/bin/bash
matedialog --info --text="I will now update the computer"
notify-send "Updating Database..."
sudo apt-get update
notify-send "Unpacking Updates..."
sudo apt-get upgrade
notify-send "All Done!"

matedialog --question --text="Do you want to reboot?" --ok-label="Sure" --cancel-label="Fuck Off"

if [ $? -eq 0 ]
then
	echo "YEP"
	sudo reboot
else
	echo "NAH"
fi

exit 0
