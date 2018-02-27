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
# OWO.SH SCRIPT.
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

scriptdir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
owodir="$HOME/.config/owo"

if [ -d $owodir ]; then

	cp $owodir/conf.cfg $owodir/conf.cfg.bak
fi

if [ ! -d $owodir ]; then
	mkdir -p $owodir
	sudo chown -R $USER:$USER $owodir
fi

cp -r $scriptdir/* $owodir

# Give directory ownership to the actual user
chown -R $(whoami | awk '{print $1}') $owodir

# Create a symbolic link to /usr/local/bin
if [ ! -f /usr/local/bin/owo ]; then
  sudo ln -s $owodir/script.sh /usr/local/bin/owo
fi
function is_mac() {
	uname | grep -q "Darwin"
}


# Install dependencies

dependencies=0

if is_mac; then
	echo "INFO  : Dependencies are unavaliable for Mac."
	echo "INFO  : Please run \"owo --check\" to check later on."
else
	(command -v notify-send >/dev/null 2>&1 && echo "FOUND : found notify-send") || { echo "Notify-send not found. Please install it via your package manager."; dependencies=1; }
	(command -v maim >/dev/null 2>&1 && echo "FOUND : found maim") || { echo "Maim not found. Please install it via your package manager."; dependencies=1; }
	(command -v xclip >/dev/null 2>&1 && echo "FOUND : found xclip") || { echo "Xclip not found. Please install it via your package manager."; dependencies=1; }
	(command -v slop >/dev/null 2>&1 && echo "FOUND : found scrot") || { echo "Slop not found. Please install via your package manager."; dependencies=1; }
  if [ $dependencies -eq 1 ]; then
    echo
    echo "Please install the missing dependencie(s) then run this script again."
    exit 1
  fi
fi

# Tell the user its done!
echo "INFO  : Installation finished of owo.sh. Use it like \"owo file.png\""
echo "The config is in ~/.config/owo"
