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
# A big thankyou to jomo/imgur-screenshot to which i've edited parts
# of his script into my own.

current_version="v0.0.7"

##################################

if [ ! -d "${HOME}/.config/owo/" ]; then
	echo "INFO  : Could not find file, downloading..."
	mkdir -p ${HOME}/.config/owo/
	curl -s -o ${HOME}/.config/owo/conf.cfg https://cdn.rawgit.com/whats-this/owo.sh/master/conf.cfg
fi
source ${HOME}/.config/owo/conf.cfg

key=$userkey >&2

directoryname=$scr_directory >&2
filename=$scr_filename >&2
path=$scr_path >&2

##################################

function is_mac() {
	uname | grep -q "Darwin"
}

function check_key() {
	if [ -z "$key" ]; then
		echo "INFO  : \$key not found, please enter your key."
		read key
		if [[ -z "$key" ]]; then
			check_key
		fi
	fi
}

##################################

if [ "${1}" = "--h" ] || [ "${1}" = "--help" ]; then
	echo "usage: ${0} [-h | --check | -v]"
	echo ""
	echo "   -h --help                   Show this help screen to you."
	echo "   -v --version                Show current application version."
	echo "   -c --check                  Checks if dependencies are installed."
	echo "      --update                 Checks if theres an update available."
	echo "   -l --shorten                Begins the url shortening process."
	echo "   -s --screenshot             Begins the screenshot uploading process."
	echo ""
	exit 0
fi

##################################

if [ "${1}" = "--v" ] || [ "${1}" = "--version" ]; then
	echo "INFO  : You are on version $current_version"
	exit 0
fi

##################################

if [ "${1}" = "-c" ] || [ "${1}" = "--check" ]; then
	(which grep &>/dev/null && echo "FOUND : found grep") || echo "ERROR : grep not found"
	if is_mac; then
		if which terminal-notifier &>/dev/null; then
			echo "FOUND : found terminal-notifier"
		else
			echo "ERROR : terminal-notifier not found"
		fi
		(which screencapture &>/dev/null && echo "FOUND : found screencapture") || echo "ERROR : screencapture not found"
		(which pbcopy &>/dev/null && echo "FOUND : found pbcopy") || echo "ERROR : pbcopy not found"
	else
		(which notify-send &>/dev/null && echo "FOUND : found notify-send") || echo "ERROR : notify-send (from libnotify-bin) not found"
		(which maim &>/dev/null && echo "FOUND : found maim") || echo "ERROR : maim not found"
		(which xclip &>/dev/null && echo "FOUND : found xclip") || echo "ERROR : xclip not found"
	fi
	(which curl &>/dev/null && echo "FOUND : found curl") || echo "ERROR : curl not found"
	exit 0
fi

##################################

if [ "${1}" = "--update" ]; then
	remote_version="$(curl --compressed -fsSL --stderr - "https://api.github.com/repos/whats-this/owo.sh/releases" | egrep -m 1 --color 'tag_name":\s*".*"' | cut -d '"' -f 4)"
	if [ "${?}" -eq "0" ]; then
		if [ ! "${current_version}" = "${remote_version}" ] && [ ! -z "${current_version}" ] && [ ! -z "${remote_version}" ]; then
			echo "INFO  : Update found!"
			echo "INFO  : Version ${remote_version} is available (You have ${current_version})"
			echo "INFO  : Check https://github.com/whats-this/owo.sh/releases/${remote_version} for more info."
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

	check_key

	if [ -z "${2}" ]; then
		if is_mac; then
			terminal-notifier -title owo.whats-th.is -message "Please enter the URL you wish to shorten." -appIcon ./icon.icns
		else
			notify-send owoshorten "Please enter the URL you wish to shorten."
		fi

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
			if is_mac; then
				echo $result | pbcopy
				terminal-notifier -title owo.whats-th.is -message "Copied the link to the keyboard." -appIcon ./icon.icns
			else
				echo $result | xclip -i -sel c -f |xclip -i -sel p
				notify-send owo.whats-th.is "Copied the link to the keyboard."
				exit
			fi
		else
			notify-send owoshorten "Shortening failed!"
		fi
	else
		if is_mac; then
			terminal-notifier -title owo.whats-th.is -message "Link is not valid!" -appIcon ./icon.icns
		else
			notify-send owoshorten "Link is not valid!"
		fi
		echo "ERROR : Link is not valid!"
	fi

	exit 0
fi

##################################

if [ "${1}" = "-s" ] || [ "${1}" = "--screenshot" ]; then

	check_key

	# Alert the user that the upload has begun.
	if is_mac; then
		terminal-notifier -title owo.whats-th.is -message "Select an area to begin the upload." -appIcon ./icon.icns
	else
		notify-send owo.whats-th.is "Select an Area to Upload."
	fi

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

	if is_mac; then
		if egrep -q '"success":\s*true' <<< "${upload}"; then
			item="$(egrep -o '"url":\s*"[^"]+"' <<<"${upload}" | cut -d "\"" -f 4)"
			echo "https://owo.whats-th.is/$item" | pbcopy
			terminal-notifier -title "Upload complete!" -message "Copied the link to your clipboard." -appIcon ./icon.icns
		else
			terminal-notifier -title "Upload failed!" -message "Please check your logs for details." -appIcon ./icon.icns
			echo "UPLOAD FAILED" > log.txt
			echo "The server left the following response" >> log.txt
			echo "--------------------------------------" >> log.txt
			echo " " >> log.txt
			echo "    " $upload >> log.txt
		fi
	else
		if egrep -q '"success":\s*true' <<< "${upload}"; then
			item="$(egrep -o '"url":\s*"[^"]+"' <<<"${upload}" | cut -d "\"" -f 4)"
			echo "https://owo.whats-th.is/$item" | xclip -i -sel c -f | xclip -i -sel p
			notify-send -a owoscreenshot "Upload complete" "Copied the link to your clipboard." -t 500
		else
			notify-send -a owoscreenshot "Upload Failed" "Please check your logs for details." -i "$errnum" -t 500
			echo "UPLOAD FAILED" > log.txt
			echo "The server left the following response" >> log.txt
			echo "--------------------------------------" >> log.txt
			echo " " >> log.txt
			echo "    " $upload >> log.txt
		fi
	fi

	exit 0

fi

##################################

if [ ! -n "$1" ]; then
	echo "ERROR : Incorrect Syntax."
	echo "ERROR : Please use \"owo file.png\""
	exit 1
fi

check_key

entry=$1
upload=$(curl -F "files[]=@"$entry";type=image/png" https://api.awau.moe/upload/pomf?key="$key")
echo "RESP  : " $upload
echo $upload | xclip -i -sel c -f | xclip -i -sel p
