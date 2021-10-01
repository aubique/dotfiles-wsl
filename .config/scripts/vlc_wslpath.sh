#!/bin/bash

VLC_EXEC='"$env:ProgramFiles\VideoLAN\VLC\vlc.exe"'
FILEPATH=\'\"file:///$(wslpath -m "$1")\"\'

shift
#echo "${@:2}"
echo "dir: $FILEPATH"

while [ -n "$1" ]; do
	ARGS="$ARGS,\"$1\""
	echo "arg: $1"
	shift
done

powershell.exe Start-Process -FilePath $VLC_EXEC -ArgumentList $FILEPATH$ARGS
echo "powershell.exe Start-Process -FilePath $VLC_EXEC -ArgumentList $FILEPATH$ARGS"
