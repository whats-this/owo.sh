#!/bin/bash
#                                   _                 _
#                                  | |               | |
#   _____      _____    _   _ _ __ | | ___   __ _  __| | ___ _ __
#  / _ \ \ /\ / / _ \  | | | | '_ \| |/ _ \ / _` |/ _` |/ _ \ '__|
#  |(_) \ V  V / (_)|  | |_| | |_) | | (_) | (_| | (_| |  __/ |
#  \___/ \_/\_/ \___/   \__,_| .__/|_|\___/ \__,_|\__,_|\___|_|
#                            | |
#                            |_|
#
# OWOUPLOADER.SH SCRIPT.
# ----------------------
#
# This script is designed for you to be able to run the
# "owo file.png" command from anywhere in your terminal
# client and for it to work.

##################################
if [ ! $(id -u) -ne 0 ]; then
 	echo "ERROR : This script cannot be run as sudo."
 	echo "ERROR : You need to remove the sudo from \"sudo ./setup.sh\"."
 	exit 1
fi
 ##################################

if [ "${1}" = "--uninstall" ]; then

	rm /usr/local/bin/owo
	echo "INFO  : Uninstallation of owo.sh finished!"
	echo "INFO  : However APT packages have not been removed."

	exit 0
fi

##################################

scriptdir=$(dirname $(which $0))
owodir="$HOME/.config/owo"

if [ ! -d $owodir ]; then
	mkdir $owodir
	cp -r $scriptdir/* $owodir
fi

# Give directory ownership to the actual user
chown -R $(who am i | awk '{print $1}') $owodir

# Create a symbolic link to /usr/local/bin
ln -s $owodir/script.sh /usr/local/bin/owo

function is_mac() {
	uname | grep -q "Darwin"
}


# Install dependencies
if is_mac; then
	echo "INFO  : Dependencies are unavaliable for Mac."
	echo "INFO  : Please run \"owo --check\" to check later on."
else
	(which notify-send &>/dev/null && echo "FOUND : found screencapture") || apt-get install notify-send
	(which maim &>/dev/null && echo "FOUND : found maim") || apt-get install maim
	(which xclip &>/dev/null && echo "FOUND : found xclip") || apt-get install xclip
fi

# Tell the user its done!
echo "INFO  : Installation finished of owo.sh. Use it like \"owo file.png\""
echo "The config is in ~/.config/owo"
