##!/bin/bash
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
# This script allows for native support to upload to the image server
# and url shortener component of whats-th.is. Through this you can do
# plethora of actions.
#
# A big thank you to jomo/imgur-screenshot to which I've edited parts
# of his script into my own.
trap '' 2
if [ ! "$(id -u)" -ne 0 ]; then
	echo "ERROR : This script cannot be run as sudo."
	echo "ERROR : You need to remove the sudo from \"sudo ./setup.sh\"."
	exit 2
fi

owodir="$HOME/.config/owo"

current_version="v0.0.19"
##################################


if [ ! -d "$owodir" ]; then
	echo "INFO  : Could not find config directory. Please run setup.sh"
	exit 1
fi

source "$owodir"/conf.cfg

key="$userkey" >&2

# Split URLs by ;
IFS=';' read -ra output_urls <<< "$finished_url" >&2
if [ ${#output_urls[@]} -le 1 ]; then
	output_url="$finished_url" >&2
else
	output_url="${output_urls[$RANDOM % ${#output_urls[@]} ]}"
fi

directoryname="$scr_directory" >&2
filename="$scr_filename" >&2
path="$scr_path" >&2
no_notify="$no_notify" >&2
print_debug="$debug" >&2
scr_cursor="$cap_cursor" >&2

IFS=';' read -ra shorten_urls <<< "$shorten_url" >&2
if [ ${#shorten_urls[@]} -le 1 ]; then
	shorten_url="$shorten_url" >&2
else
	shorten_url="${shorten_urls[$RANDOM % ${#shorten_urls[@]} ]}"
fi
##################################

function is_mac() {
	uname | grep -q "Darwin"
}

function check_key() {
	if [ -z "$key" ]; then
		echo "INFO  : \$key not found, please set \$userkey in your config file."
		echo "INFO  : You can find the key in "$owodir"/conf.cfg"
		exit 1
	fi
}

function notify() {
	if [ "$no_notify" == "false" ]; then
		if is_mac; then
			/usr/local/bin/terminal-notifier -title owo.whats-th.is -message "${1}" -appIcon $owodir/icon.icns -timeout 5
		else
			notify-send owo.whats-th.is "${1}" -i "$owodir"/icon.png
		fi
	fi
}

function delete_scr() {
	if [ "$keep_scr" != "true" ]; then
		rm "${path}${filename}"
	fi
}

function clipboard() {
	if is_mac; then
		echo "${1}" | tr -d "\n\r" | pbcopy
	else
		echo "${1}" | tr -d "\n\r" | xclip -i -sel c -f | xclip -i -sel p
	fi
}

function keyset() {
	read -p "Please enter your API key: " keystring
	sed -i /userkey=/c\userkey="$keystring" "$owodir"/conf.cfg
	echo "Saved."
	echo ""
	settings
}

function finishset() {
	read -p "Please enter your preferred URLs for upload/screenshot (separated by semicolons ';'): " finishstring
	if [ "$finishstring" = "q" ]; then
		settings
	fi
	sed -i /finished_url=/c\finished_url="\"$finishstring\"" "$owodir"/conf.cfg
	echo "Saved."
	echo ""
	settings
}

function shortenset() {
	read -p "Please enter your preferred URLs for shortening (separated by semicolons ';'): " shortenstring
	if [ "$shortenstring" = "q" ]; then
		settings
	fi
	sed -i /shorten_url=/c\shorten_url="\"$shortenstring\"" "$owodir"/conf.cfg
	echo "Saved."
	echo ""
	settings
}

function notif_prefs() {
	read -p "Would you like to recieve notifications from OwO.sh? (y/n/q) " choice
	case "$choice" in
		y|Y ) sed -i /no_notify=/c\no_notify=false "$owodir"/conf.cfg; echo "Saved."; echo ""; misc;;
		n|N ) sed -i /no_notify=/c\no_notify=true "$owodir"/conf.cfg; echo "Saved."; echo ""; misc;;
		q|Q ) echo ""; misc;;
		* ) echo "Invalid selection. Please choose y or n.";;
	esac
}

function scrsave_prefs() {
	read -p "Would you like to save screenshots to your local? (y/n/q) " choice
	case "$choice" in
		y|Y ) sed -i /keep_scr=/c\keep_scr=true "$owodir"/conf.cfg; echo "Saved."; echo ""; misc;;
		n|N ) sed -i /keep_scr=/c\keep_scr=false "$owodir"/conf.cfg; echo "Saved."; echo ""; misc;;
		q|Q ) echo ""; misc;;
		* ) echo "Invalid selection. Please choose y or n.";;
	esac
}

function cursor_prefs() {
	read -p "Would you like to capture the cursor in screenshots? (y/n/q) " choice
	case "$choice" in
		y|Y ) sed -i /cap_cursor=/c\cap_cursor=true "$owodir"/conf.cfg; echo "Saved."; echo ""; misc;;
		n|N ) sed -i /cap_cursor=/c\cap_cursor=false "$owodir"/conf.cfg; echo "Saved."; echo ""; misc;;
		q|Q ) echo ""; misc;;
		* ) echo "Invalid selection. Please choose y or n.";;
	esac
}

function xclip_prefs() {
	read -p "Would you like links to be copied to your clipboard? (y/n/q) " choice
	case "$choice" in
		y|Y ) sed -i /scr_copy=/c\scr_copy=true "$owodir"/conf.cfg; sed -i /url_copy=/c\url_copy=true $owodir/conf.cfg; echo "Saved."; echo ""; misc;;
		n|N ) sed -i /scr_copy=/c\scr_copy=false "$owodir"/conf.cfg; sed -i /url_copy=/c\url_copy=false $owodir/conf.cfg; echo "Saved."; echo ""; misc;;
		q|Q ) echo ""; misc;;
		* ) echo "Invalid selection. Please choose y or n."; misc;;
	esac
}

function misc() {
	echo "Miscellaneous Settings"
	echo "1) Notification preferences"
	echo "2) Screenshot saving preferences"
	echo "2) Screenshot cursor preferences"
	echo "4) Clipboard copying preferences"
	echo "5) Go back"
	read -p "Please enter your selection: " selection
	case "$selection" in
		1 ) notif_prefs;;
		2 ) scrsave_prefs;;
		3 ) cursor_prefs;;
		4 ) xclip_prefs;;
		5 ) settings;;
		* ) echo "Invalid selection. Please choose 1, 2 or 3."; misc;;
	esac
}

function settings() {
	echo "OwO.sh Settings"
	echo "1) API Key"
	echo "2) Upload/Screenshot URL"
	echo "3) Shorten URL"
	echo "4) Misc"
	echo "q) Quit"
	read -p "Please enter your selection: " selection
	case "$selection" in
		1 ) keyset;;
		2 ) finishset;;
		3 ) shortenset;;
		4 ) misc;;
		q ) clear; exit 0;;
		* ) echo "Invalid selection. Please choose 1, 2, 3, or 4."; settings;;
	esac
}


function shorten() {
	check_key

	if [ -z "${2}" ]; then
		notify "Please enter the URL you wish to shorten."
		echo "INFO  : Please enter the URL you wish to shorten."

		read url
	else
		url="${2}"
	fi
	#Check if the URL entered is valid.
	regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
	if [[ "$url" =~ $regex ]]; then
		result=$(curl -s -G "https://api.awau.moe/shorten/polr?action=shorten" --data-urlencode "key=$key" --data-urlencode "url=$url" -H "User-Agent: WhatsThisClient (https://github.com/whats-this/owo.sh, v0.0.19)")

		#Check if the URL got sucessfully shortened.
		if grep -q "https://" <<< "${result}"; then
			code=$(echo "$result" | sed 's/.*oe//')
			result="https://$shorten_url$code"
			d="$1"
			if [ "$d" = "true" ]; then
				clipboard "$result"
				echo "$result"
				notify "Copied the link to the keyboard."
				echo "$(date): $result" >> "$owodir"/shorten.log
			else
				echo "$result"
			fi
		else
			notify "Shortening failed!"
		fi
	else
		notify "URL is not valid!"
		exit 4
	fi
}

function screenshot() {
	check_key

	# Alert the user that the upload has begun.
	notify "Select an area to begin the upload."

	# Begin our screen capture.
	if [[ $fullscreen ]]; then 
		if is_mac; then
			screencapture -o "${path}${filename}"
		elif [[ $scr_cursor ]]; then 
			maim -u "${path}${filename}"
		else
			maim "${path}${filename}"
		fi
	else
		if is_mac; then
			screencapture -o -i "${path}${filename}"
		elif [[ $scr_cursor ]]; then
			maim -s -u "${path}${filename}"
		else
			maim -s "${path}${filename}"
		fi
	fi


	# Make a directory for our user if it doesnt already exsist.
	mkdir -p "$path"

	# Open our new entry to use it!
	entry="${path}${filename}"
	upload=$(curl -s -F "files[]=@$entry;type=image/png" https://api.awau.moe/upload/pomf?key="$key"  -H "User-Agent: WhatsThisClient (https://github.com/whats-this/owo.sh, v0.0.19)")

	if [ "$print_debug" = true ] ; then
		echo $upload
	fi

	if grep -E -q '"success":\s*true' <<< "${upload}"; then
		item="$(grep -E -o '"url":\s*"[^"]+"' <<<"${upload}" | cut -d "\"" -f 4)"
		d="$1"
		if [ "$d" = true ]; then
			if [ "$scr_copy" = true ]; then
				clipboard "https://$output_url/$item"
				notify "Upload complete! Copied the link to your clipboard."
				echo "https://$output_url/$item"
			else
				echo "https://$output_url/$item"
			fi
		else
			output="https://$output_url/$item"
		fi
		echo "$(date): https://$output_url/$item" >> $owodir/screenshot.log
	else
		notify "Upload failed! Please check your logs ("$owodir"/log.txt) for details."
		echo "UPLOAD FAILED" > "$owodir"/log.txt
		echo "The server left the following response" >> "$owodir"/log.txt
		echo "--------------------------------------" >> "$owodir"/log.txt
		echo " " >> "$owodir"/log.txt
		echo "    " "$upload" >> "$owodir"/log.txt
		exit 1
	fi
	delete_scr
}

function upload() {
	entry="$1"
	if [ ! -f "$entry" ];
	then
		echo "$entry not found! Exiting..."
		exit 1
	fi
	check_key

	mimetype=$(file -b --mime-type "$entry")

	filesize=$(wc -c <"$entry")
	if [[ "$filesize" -le 83886081 ]]; then
		upload=$(curl -s -F "files[]=@$entry;type=$mimetype" https://api.awau.moe/upload/pomf?key="$key" -H "User-Agent: WhatsThisClient (https://github.com/whats-this/owo.sh, v0.0.19)")
		item="$(grep -E -o '"url":\s*"[^"]+"' <<<"${upload}" | cut -d "\"" -f 4)"
	else
		echo "ERROR : File size too large or another error occured!"
		exit 1
	fi


	if grep -E -q '"success":\s*true' <<< "${upload}"; then
		d="$2"
		if [ "$d" = true ]; then
			clipboard "https://$output_url/$item"
			echo "https://$output_url/$item"
			echo "$(date): https://$output_url/$item" >> $owodir/upload.log
		else
			eval output="https://$output_url/$item"
		fi


	else
		notify "Upload failed! Please check your logs ($owodir/log.txt) for details."
		echo "UPLOAD FAILED" > "$owodir"/log.txt
		echo "The server left the following response" >> "$owodir"/log.txt
		echo "--------------------------------------" >> "$owodir"/log.txt
		echo " " >> "$owodir"/log.txt
		echo "    " "$upload" >> "$owodir"/log.txt
		exit 1
	fi
}

function runupdate() {
	curl -L "https://owo.sh" | bash
}

function screenrecord() {

	if [ "$1" == "stop" ]; then
		if [ ! -f ~/.config/owo/gif.pid ]; then
			echo "Pidfile doesn't exist, exiting..."
			exit 1
		fi
		echo "Stopping gif recorder..."
		kill -INT $(cat ~/.config/owo/gif.pid)
		exit 0
	elif [ "$1" == "clean" ]; then
		rm ~/.config/owo/gif.pid
		exit 0
	elif [ "$1" != "rec" ]; then
		echo "Unknown subcommand $1. Try \"rec\", \"stop\" or \"clean\""
		exit 1
	elif [ -f ~/.config/owo/gif.pid ]; then
		echo "Pidfile exists, exiting..."
		exit 1
	fi
	TMP_AVI=$(mktemp /tmp/outXXXXXXXXXX.avi)
	TMP_PALETTE=$(mktemp /tmp/outXXXXXXXXXX.png)
	TMP_GIF=$(mktemp /tmp/outXXXXXXXXXX.gif)
	function cleanup() {
		rm ~/.config/owo/gif.pid
		rm "$TMP_AVI"
		rm "$TMP_PALETTE"
		rm "$TMP_GIF"
	}
	function on_sigint() {
		echo "Stopping gif recorder..."
		kill -INT $(cat "$owodir"/gif.pid)
	}
	trap cleanup EXIT
	trap on_sigint SIGINT

	touch ~/.config/owo/gif.pid
	read -r X Y W H G ID < <(slop -f "%x %y %w %h %g %i" -q)
	if [ -z "$X" ]; then
		echo "Cancelled..."
		exit 1
	fi
	ffmpeg -loglevel warning -y -f x11grab -show_region 1 -framerate 15 \
		-s "$W"x"$H" -i :0.0+"$X","$Y" -codec:v huffyuv   \
		-vf crop="iw-mod(iw\\,2):ih-mod(ih\\,2)" "$TMP_AVI" &
	PID="$!"
	echo "$PID" > ~/.config/owo/gif.pid &
	wait "$PID"
	# TODO webm
	# ffmpeg -y -loglevel warning -i $TMP_AVI -c:v libvpx -b:v 1M -c:a libvorbis $TMP_GIF
	ffmpeg -v warning -i "$TMP_AVI" -vf "fps=15,palettegen=stats_mode=full" -y $TMP_PALETTE
	ffmpeg -v warning -i "$TMP_AVI" -i "$TMP_PALETTE" -lavfi "fps=15 [x]; [x][1:v] paletteuse=dither=sierra2_4a" -y $TMP_GIF
	upload "$TMP_GIF" true
}
##################################

if [ "${1}" = "-h" ] || [ "${1}" = "--help" ] || [ "${1}" = "" ]; then
	echo "usage: ${0} [-h | --check | -v]"
	echo ""
	echo "   -h  --help                 Show this help screen to you."
	echo "   -v  --version              Show current application version."
	echo "   -c  --check                Checks if dependencies are installed."
	echo "       --update               Checks if theres an update available."
	echo "   -l  --shorten              Begins the url shortening process."
	echo "   -s  --screenshot           Begins the screenshot uploading process."
	echo "   -sf --fullscreen           Begins the fullscreen screenshot uploading process."
	echo "   -sl                        Takes a screenshot and shortens the URL."
	echo "   -ul                        Uploads file and shortens URL."
	echo "   -gr                        Starts the gif uploading process."
	echo "   -gs                        Stops the gif uploader."
	echo "   --settings                 Opens settings page for OwO.sh"
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
	if [ "${1}" = "-C" ]; then
		owodir="${4}"
	fi
	remote_version="$(curl --compressed -fsSL --stderr - "https://api.github.com/repos/whats-this/owo.sh/releases" | grep -E -m 1 --color 'tag_name":\s*".*"' | cut -d '"' -f 4)"
	if [ "${?}" -eq "0" ]; then
		if [ ! "${current_version}" = "${remote_version}" ] && [ ! -z "${current_version}" ] && [ ! -z "${remote_version}" ]; then
			echo "INFO  : Update found!"
			echo "INFO  : Version ${remote_version} is available (You have ${current_version})"

			echo "ALERT : You already have a configuration file in $owodir"
			echo "ALERT : Updating might break this config, are you sure you want to update?"

			read -p "INFO  : Continue anyway? (Y/N)" choice
			case "$choice" in
				y|Y ) runupdate;;
				n|N ) exit 0;;
				* ) echo "ERROR : That is an invalid response, (Y)es/(N)o.";;
			esac


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
if [ "${1}" = "--settings" ]; then
	settings
	exit 0
fi
##################################

if [ "${1}" = "-l" ] || [ "${1}" = "--shorten" ]; then
	shorten true "${2}"
	exit 0
fi

##################################

if [ "${1}" = "-s" ] || [ "${1}" = "--screenshot" ]; then
	screenshot true
	exit 0
fi

##################################

if [ "${1}" = "-sf" ] || [ "${1}" = "--fullscreen" ]; then
	fullscreen=true
	screenshot true
	exit 0
fi

##################################

if [ "${1}" = "-sf" ] || [ "${1}" = "--fullscreen" ]; then
    fullscreen=true
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
	upload "${2}" false
	shorten true "$output"
	echo "$result"

	if is_mac; then
		echo "$result" | pbcopy
	else
		echo "$result" | xclip -i -sel c -f | xclip -i -sel p
	fi
	notify "Copied link to keyboard."
	exit 0
fi

if [ "${1}" = "-gr" ]; then
	screenrecord rec
	exit 0
fi

if [ "${1}" = "-gs" ]; then
	screenrecord stop
	exit 0
fi

upload "${1}" true
echo "$output"
notify "Copied link to keyboard."
