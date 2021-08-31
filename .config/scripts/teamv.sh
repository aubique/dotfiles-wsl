#!/bin/bash

loop_teamviewer () {
    i=1
    sp='/-\|'
    teamv_exec=true
    unset is_interrupted
    echo "Executing TeamViewer..."
    echo "Type <Ctrl+C> to exit this while loop"

    trap 'teamv_exec=false; is_interrupted=true' INT
    while $teamv_exec; do
        printf "\b${sp:i++%${#sp}:1}"
        [[ ! $(tasklist.exe | grep TeamViewer.exe) ]] && teamv_exec=false
        sleep 2
    done
    trap 'trap - INT; kill -INT $$' INT
}

kill_teamviewer () {
    echo
    /mnt/c/Windows/System32/taskkill.exe /IM teamviewer.exe
    wait
    /mnt/c/Windows/System32/taskkill.exe /IM teamviewer.exe /F
    echo 'TeamViewer process is terminated.'
}

/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command 'Start-Process -FilePath ${ENV:ProgramFiles(x86)}\TeamViewer\TeamViewer.exe -ArgumentList --Minimize'
wait
loop_teamviewer
[[ -n $is_interrupted ]] && kill_teamviewer && restart_explorer
