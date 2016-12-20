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
# This script allows for native support to upload to the image server
# and url shortener component of whats-th.is. Through this you can do
# plethora of actions.
#
# A big thank you to jomo/imgur-screenshot to which I've edited parts
# of his script into my own.

if [ ! $(id -u) -ne 0 ]; then
	echo "ERROR : This script cannot be run as sudo."
	echo "ERROR : You need to remove the sudo from \"sudo ./setup.sh\"."
	exit 1
fi

current_version="v0.0.12"
config_version=1

##################################

owodir="$HOME/.config/owo"

if [ ! -d $owodir ]; then
	echo "INFO  : Could not find config directory. Please run setup.sh"
	exit 1
fi
source $owodir/conf.cfg

key=$userkey >&2

directoryname=$scr_directory >&2
filename=$scr_filename >&2
path=$scr_path >&2

print_debug=$debug >&2

##################################

function is_mac() {
	uname | grep -q "Darwin"
}

function check_key() {
	if [ -z "$key" ]; then
		echo "INFO  : \$key not found, please set \$userkey in your config file."
		echo "INFO  : You can find the key in $owodir/conf.cfg"
		exit 1
	fi
}

function notify() {
	if is_mac; then
		terminal-notifier -title owo.whats-th.is -message "${1}" -appIcon $owodir/icon.icns
	else
		notify-send owo.whats-th.is "${1}" -i $owodir/icon.png
	fi
}

function shorten() {
	check_key

	if [ -z "${2}" ]; then
		notify "Please enter the URL you wish to shorten."

		echo "INFO  : Please enter the URL you wish to shorten."
		read url
	else
		url=${2}
	fi

	#Check if the URL entered is valid.
	regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
	if [[ $url =~ $regex ]]; then
		result=$(curl "https://api.awau.moe/shorten/polr?action=shorten&key=$key&url=$url")

		#Check if the URL got sucessfully shortened.
		if grep -q "https://" <<< "${result}"; then
			d=$1
			if [ "$d" = "true" ]; then
				if [ "$url_copy" = "true" ]; then
					if is_mac; then
						echo $result | pbcopy
					else
						echo $result | xclip -i -sel c -f | xclip -i -sel p
					fi
					notify "Copied the link to the keyboard."
				else
					echo $result
				fi
			else
				echo $result
			fi
		else
			notify "Shortening failed!"
		fi
	else
		notify "URL is not valid!"
	fi
}

function screenshot() {
	check_key

	# Alert the user that the upload has begun.
	notify "Select an area to begin the upload."

	# Begin our screen capture.
	if is_mac; then
		screencapture -o -i $path$filename
	else
		maim -s $path$filename
	fi

	# Make a directory for our user if it doesnt already exsist.
	mkdir -p $path

	# Open our new entry to use it!
	entry=$path$filename
	upload=$(curl -F "files[]=@"$entry";type=image/png" https://api.awau.moe/upload/pomf?key="$key")

	if [ "$print_debug" = true ] ; then
		echo $upload
	fi

	if egrep -q '"success":\s*true' <<< "${upload}"; then
		item="$(egrep -o '"url":\s*"[^"]+"' <<<"${upload}" | cut -d "\"" -f 4)"
		d=$1
		if [ "$d" = true ]; then
			if [ "$scr_copy" = true ]; then
				if is_mac; then
					echo "https://owo.whats-th.is/$item" | pbcopy
				else
					echo "https://owo.whats-th.is/$item" | xclip -i -sel c -f | xclip -i -sel p
				fi
				notify "Upload complete! Copied the link to your clipboard."
			else
				echo "https://owo.whats-th.is/$item"
			fi
		else
				output="https://owo.whats-th.is/$item"
		fi
	else
		notify "Upload failed! Please check your logs ($owodir/log.txt) for details."
		echo "UPLOAD FAILED" > $owodir/log.txt
		echo "The server left the following response" >> $owodir/log.txt
		echo "--------------------------------------" >> $owodir/log.txt
		echo " " >> $owodir/log.txt
		echo "    " $upload >> $owodir/log.txt
	fi
}

function upload() {



	check_key

	entry=$1
	mimetype=$(file -b --mime-type $entry)
	upload=$(curl -F "files[]=@"$entry";type=$mimetype" https://api.awau.moe/upload/pomf?key="$key")
	item="$(egrep -o '"url":\s*"[^"]+"' <<<"${upload}" | cut -d "\"" -f 4)"

	if [ "$print_debug" = true ] ; then
		echo $upload
	fi

	d=$2
	if [ "$d" = true ]; then
		echo "RESP  : $upload"
		echo "URL   : https://owo.whats-th.is/$item"
	else
		output="https://owo.whats-th.is/$item"
	fi
}

##################################

if [ "${1}" = "-h" ] || [ "${1}" = "--help" ]; then
	echo "usage: ${0} [-h | --check | -v]"
	echo ""
	echo "   -h --help                  Show this help screen to you."
	echo "   -v --version               Show current application version."
	echo "   -c --check                 Checks if dependencies are installed."
	echo "      --update                Checks if theres an update available."
	echo "   -l --shorten               Begins the url shortening process."
	echo "   -s --screenshot            Begins the screenshot uploading process."
	echo "   -sl                        Takes a screenshot and shortens the URL."
	echo "   -ul                        Uploads file and shortens URL."
	echo ""
	exit 0
fi

##################################

if [ "${1}" = "-v" ] || [ "${1}" = "--version" ]; then
	echo "INFO  : You are on version $current_version"
	exit 0
fi

##################################

if [ "${1}" = "-c" ] || [ "${1}" = "--check" ]; then
	if is_mac; then
		(which terminal-notifier &>/dev/null && echo "FOUND : found terminal-notifier") || echo "ERROR : terminal-notifier not found"
		(which screencapture &>/dev/null && echo "FOUND : found screencapture") || echo "ERROR : screencapture not found"
		(which pbcopy &>/dev/null && echo "FOUND : found pbcopy") || echo "ERROR : pbcopy not found"
	else
		(which notify-send &>/dev/null && echo "FOUND : found notify-send") || echo "ERROR : notify-send (from libnotify-bin) not found"
		(which maim &>/dev/null && echo "FOUND : found maim") || echo "ERROR : maim not found"
		(which xclip &>/dev/null && echo "FOUND : found xclip") || echo "ERROR : xclip not found"
	fi
	(which curl &>/dev/null && echo "FOUND : found curl") || echo "ERROR : curl not found"
	(which grep &>/dev/null && echo "FOUND : found grep") || echo "ERROR : grep not found"
	exit 0
fi

##################################

if [ "${1}" = "--update" ]; then
	remote_version="$(curl --compressed -fsSL --stderr - "https://api.github.com/repos/whats-this/owo.sh/releases" | egrep -m 1 --color 'tag_name":\s*".*"' | cut -d '"' -f 4)"
	if [ "${?}" -eq "0" ]; then
		if [ ! "${current_version}" = "${remote_version}" ] && [ ! -z "${current_version}" ] && [ ! -z "${remote_version}" ]; then
			echo "INFO  : Update found!"
			echo "INFO  : Version ${remote_version} is available (You have ${current_version})"
			git -C pull origin ${remote_version}
		elif [ -z "${current_version}" ] || [ -z "${remote_version}" ]; then
			echo "ERROR : Version string is invalid."
			echo "INFO  : Current (local) version: '${current_version}'"
			echo "INFO  : Latest (remote) version: '${remote_version}'"
		else
			echo "INFO  : Version ${current_version} is up to date."
		fi
	else
		echo "ERROR : Failed to check for latest version: ${remote_version}"
	fi

	exit 0
fi

##################################

if [ "${1}" = "-l" ] || [ "${1}" = "--shorten" ]; then
	shorten true
	exit 0
fi



##################################

if [ "${1}" = "-s" ] || [ "${1}" = "--screenshot" ]; then
	screenshot true
	exit 0
fi

##################################
if [ "${1}" = "-sl" ]; then
	screenshot false
	shorten true $output
	exit 0
fi


##################################
if [ "${1}" = "-ul" ]; then
	if [ -z "$2" ]; then
		echo "ERROR : Sorry, but thats incorrect syntax."
		echo "ERROR : Please use \"owo file.png\""
		exit 1
	fi
	upload ${2} false
	shorten true $output
	echo $result
	exit 0
fi
upload ${1} true
