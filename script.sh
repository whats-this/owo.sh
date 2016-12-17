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
# This script is a port of a previous written script meant for uploading to
# catgirlsare.sexy, however it had to be modified (slightly) in order to be
# fixed for owo.whats-th.is, please enjoy!
# 
# Also a big thankyou to jomo/imgur-screenshot to which i've edited parts
# of his script into my own, which included compatability with now, Linux!

current_version="v0.0.4"

##################################

if [ ! -d "${HOME}/Documents/.owo/" ]; then 
	echo "Could not find file, downloading..."
	mkdir -p ${HOME}/Documents/.owo/
	curl -s -o ${HOME}/Documents/.owo/conf.cfg https://cdn.rawgit.com/whats-this/owo.sh/master/conf.cfg
fi
source ${HOME}/Documents/.owo/conf.cfg

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
		echo "INF : \$key not found, please enter your key."
		read key
		if [[ -z "$key" ]]; then
			check_key
		fi
	fi
}

##################################

if [ "${1}" = "--check" ]; then
	(which grep &>/dev/null && echo "FOUND: found grep") || echo "ERROR: grep not found"
	if is_mac; then
		if which terminal-notifier &>/dev/null; then
			echo "FOUND: found terminal-notifier"
		else
			echo "ERROR: terminal-notifier not found"
		fi
		(which screencapture &>/dev/null && echo "FOUND: found screencapture") || echo "ERROR: screencapture not found"
		(which pbcopy &>/dev/null && echo "FOUND: found pbcopy") || echo "ERROR: pbcopy not found"
	else
		(which notify-send &>/dev/null && echo "FOUND: found notify-send") || echo "ERROR: notify-send (from libnotify-bin) not found"
		(which scrot &>/dev/null && echo "FOUND: found scrot") || echo "ERROR: scrot not found"
		(which xclip &>/dev/null && echo "FOUND: found xclip") || echo "ERROR: xclip not found"
	fi
	(which curl &>/dev/null && echo "FOUND: found curl") || echo "ERROR: curl not found"
	exit 0
fi

##################################

if [ "${1}" = "--help" ]; then
	echo "usage: ${0} [-h | --check | -v]"
	echo ""
	echo "      --help                   Show this help screen to you."
	echo "      --version                Show current application version."
	echo "      --check                  Checks if dependencies are installed."
	echo "      --screenshot             Begins the screenshot uploading process."
	echo "      --shorten                Begins the url shortening process."
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
if [ "${1}" = "--shorten" ]; then

  check_key

  notify-send owoshorten "Please enter the URL you wish to shorten."

  echo "Please enter the URL you wish to shorten."

  read url

  regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
  if [[ $url =~ $regex ]]; then
    result=$(curl "https://api.whats-th.is/shorten/polr?action=shorten&key=$key&url=$url")
    echo $result
    if grep -q "https://" <<< "${result}"; then
      echo $result | xclip -i -sel c -f |xclip -i -sel p
      notify-send owoshorten "Copied the link to the keyboard."
      exit
    else
      notify-send owoshorten "Shortening failed!"
    fi
  else
    notify-send owoshorten "Link is not valid!"
    echo "Link is not valid!"
  fi
fi

##################################

if [ "${1}" = "--screenshot" ]; then

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
		scrot -s $path$filename
	fi

	# Make a directory for our user if it doesnt already exsist.
	mkdir -p $path

	# Open our new entry to use it!
	entry=$path$filename
	upload=$(curl -F "files[]=@"$entry";type=image/png" https://api.whats-th.is/upload/pomf?key="$key")
	# For debugging, I echo the file.
	echo $upload

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
fi

check_key

entry=$1
upload=$(curl -F "files[]=@"$entry";type=image/png" https://api.whats-th.is/upload/pomf?key="$key")
echo "Response:" $upload
