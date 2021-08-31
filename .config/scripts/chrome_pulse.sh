#!/bin/bash

/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command 'Start-Process -WindowStyle hidden -FilePath $env:APPDATA\PulseAudio\bin\pulseaudio.exe'
wait

google-chrome 'https://dnsleaktest.com'

#google-chrome #'https://www.audiocheck.net/audiotests_stereo.php'
#google-chrome &
#PID_CHROME=$!

#wait $PID_CHROME
echo 'Chrome has been closed.'
/mnt/c/Windows/System32/taskkill.exe /IM pulseaudio.exe
#wait
echo 'Pulseaudio process is terminated.'
