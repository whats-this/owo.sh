#!/bin/bash
if [ ! $(id -u) -ne 0 ]; then
  zenity --error --text="This script cannot be run as sudo."
  exit 1
fi

ans=$(zenity  --list  --text "Choose your action" --radiolist --column "Pick" --column "Choice" FALSE Upload FALSE Screenshot FALSE Shorten)
echo $ans
if [[ $? -eq 1 ]]; then
  exit 0
fi

if [[ $ans = "Screenshot" ]]; then
  owo -s
  if [[ $? -eq 3 ]]; then
    zenity --error --text="Please put a key in ~/.config/owo/conf.cfg"
    exit 1
  fi
  if [[ $? -eq 1 ]]; then
    zenity --error --text="An unexpected error has occured. Please consult ~/.config/owo/log.txt for details."
    exit 1
  fi
  zenity --info --text="Upload Complete. URL copied to clipboard."
  exit 0
elif [[ $ans = "Upload" ]]; then
  FILE=`zenity --file-selection --title="Select a File to Upload"`
  case $? in
         0)
                zenity --info --text="\"$FILE\" selected.";;
         1)
                zenity --error --text="No file selected." && exit;;

        -1)
                zenity --error --text="An unexpected error has occurred." && exit 1;;
  esac
  sleep 2
  owo $FILE
  if [[ $? -eq 3 ]]; then
    zenity --error --text="Please put a key in ~/.config/owo/conf.cfg"
    exit 1
  fi
  if [[ $? -eq 1 ]]; then
    zenity --error --text="An unexpected error has occured. Please consult ~/.config/owo/log.txt for details."
    exit 1
  fi
  zenity --info --text="Upload Complete. URL copied to clipboard."
  exit 0
elif [[ $ans = "Shorten" ]]; then
  s_url=`zenity --entry --title="Enter URL" --text="Please enter the URL you wish to shorten."`
  owo -l $s_url
  if [[ $s_url = "" ]]; then
    zenity --error --text="URL not found!"
    exit 1
  fi
  if [[ $? -eq 3 ]]; then
    zenity --error --text="Please put a key in ~/.config/owo/conf.cfg"
    exit 1
  fi
  if [[ $? -eq 1 ]]; then
    zenity --error --text="An unexpected error has occured. Please consult ~/.config/owo/log.txt for details."
    exit 1
  fi
  zenity --info --text="Upload Complete. URL copied to clipboard."
  exit 0
fi
