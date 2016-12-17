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

#if [ "$EUID" -ne 0 ]; then 
#	echo "ERROR : You need to run the script as sudo."
#	echo "ERROR : It should look like \"sudo ./setup.sh\""
#	exit
#fi

##################################

if [ "${1}" = "--uninstall" ]; then

	rm /usr/local/bin/owo
	echo "INFO  : Uninstallation finished!"

	exit
fi

##################################

#Create a symbolic link to /usr/local/bin
sudo ln -s $HOME/Documents/.owo/script.sh /usr/local/bin/owo


# Tell the user its done!
echo "INFO  : Installation finished. Use it like \"owo file.png\""
