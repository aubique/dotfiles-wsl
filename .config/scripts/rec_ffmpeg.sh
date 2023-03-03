#!/bin/bash

#RECORD_FOLDER=$HOME/mus/_Music/rec
RECORD_FOLDER=$HOME/mus/rec

EXEC_DATE=$(date '+%Y%m%d_%H%M%S')
FILE_DIR="$(readlink -e $RECORD_FOLDER)"
FILE_NAME="rec_$EXEC_DATE.mp3"
FILE_PATH="$(wslpath -w $FILE_DIR)\\$FILE_NAME"

echo $FILE_NAME;
echo $FILE_PATH:

# Debug Echo
#cmd.exe /C ffmpeg -list_devices true -f dshow -i dummy

#powershell.exe -Command "ffmpeg -hide_banner -f dshow -i audio=\"Stereo Mix (Realtek(R) Audio)\" \"$FILE_PATH\""
cmd.exe /C ffmpeg -hide_banner -f dshow -i audio="Stereo Mix (Realtek(R) Audio)" "$FILE_PATH"
echo "---------------------------------------------------"
echo $FILE_PATH
echo $(wslpath -u "$FILE_PATH")
