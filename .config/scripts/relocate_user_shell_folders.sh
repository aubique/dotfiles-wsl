#!/usr/bin/env bash

# Script is designed to set custom location for user shell folders and link them to WSL2 $HOME.

# Features:
# - Move User Shell folder location to another drive or directory
# - Link the $HOME user folders for WSL to the existing Windows user shell folders
# - Update Windows system PATH environment variable with the links on new partition

set -e

ask_params() {
	echo

	# Parent directory (drive) for WSL2 as '/home'
	WSL_WINDATA_DRIVE="/mnt/d"

	echo "What drive do you want for WSL home directory? (Use Unix-based separator symbol)"
	read -p "WSL_WINDATA_DRIVE [default: $WSL_WINDATA_DRIVE]: " WSL_WINDATA_DRIVE_NEW
	[ "$WSL_WINDATA_DRIVE_NEW" != "" ] && export WSL_WINDATA_DRIVE=$WSL_WINDATA_DRIVE_NEW

	# Final directory containing Windows User Shell Folders, in sync with WSL $HOME
	WSL_WINDATA_USER="$WSL_WINDATA_DRIVE/home/$USER"

	echo "What directory do you prefer for User Shell Folders?"
	read -p "WSL_WINDATA_USER [default: $WSL_WINDATA_USER]: " WSL_WINDATA_USER_NEW
	[ "$WSL_WINDATA_USER_NEW" != "" ] && export WSL_WINDATA_USER=$WSL_WINDATA_USER_NEW

	# Interactive parameters
	export RUN_MAKE_DIRS=0
	export RUN_LINK_DIRS=0
	export RUN_UPDATE_PATH=0
	export RUN_MOVE_USER_SHELL_FOLDERS=0

	echo "Create directories?"
	read -p "RUN_MAKE_DIRS [default: $RUN_MAKE_DIRS]: " RUN_MAKE_DIRS_NEW
	[ "$RUN_MAKE_DIRS_NEW" != "" ] && export RUN_MAKE_DIRS=$RUN_MAKE_DIRS_NEW

	echo "Link WSL2 home folders?"
	read -p "RUN_LINK_DIRS [default: $RUN_LINK_DIRS]: " RUN_LINK_DIRS_NEW
	[ "$RUN_LINK_DIRS_NEW" != "" ] && export RUN_LINK_DIRS=$RUN_LINK_DIRS_NEW

	echo "Update Windows system PATH?"
	read -p "RUN_UPDATE_PATH [default: $RUN_UPDATE_PATH]: " RUN_UPDATE_PATH_NEW
	[ "$RUN_UPDATE_PATH_NEW" != "" ] && export RUN_UPDATE_PATH=$RUN_UPDATE_PATH_NEW

	echo "Move Windows UserShell folders?"
	read -p "RUN_MOVE_USER_SHELL_FOLDERS [default: $RUN_MOVE_USER_SHELL_FOLDERS]: " RUN_MOVE_USER_SHELL_FOLDERS_NEW
	[ "$RUN_MOVE_USER_SHELL_FOLDERS_NEW" != "" ] && export RUN_MOVE_USER_SHELL_FOLDERS=$RUN_MOVE_USER_SHELL_FOLDERS_NEW

	echo
}

set_params() {
	# Windows %UserProfile% directory
	WINUSER_DIR="$HOME/_win:$WIN_HOME"
	# Custom User folders (link/create)
	DESKTOP_DIR="$HOME/desk:$WSL_WINDATA_USER/desk"
	DOWNLOADS_DIR="$HOME/dl:$WSL_WINDATA_USER/dl"
	DOCUMENTS_DIR="$HOME/docs:$WSL_WINDATA_USER/docs"
	MUSIC_DIR="$HOME/mus:$WSL_WINDATA_USER/mus"
	PICTURES_DIR="$HOME/pics:$WSL_WINDATA_USER/pics"
	VIDEOS_DIR="$HOME/vids:$WSL_WINDATA_USER/vids"
	DEVELOPMENT_DIR="$HOME/dev:$WSL_WINDATA_DRIVE/dev"
	# Miscellaneous data directories (create)
	USRBIN_DIR="$WSL_WINDATA_DRIVE/usr/bin"
	USRLOCALBIN_DIR="$WSL_WINDATA_DRIVE/usr/local/bin"
	USRLIB_DIR="$WSL_WINDATA_DRIVE/usr/lib"
	USRSHAREDOC_DIR="$WSL_WINDATA_DRIVE/usr/share/doc"
	TMP_DIR="$WSL_WINDATA_DRIVE/tmp"
	OPT_DIR="$WSL_WINDATA_DRIVE/opt"
	REC_DIR="${MUSIC_DIR#*:}/rec"
	SCR_DIR="${PICTURES_DIR#*:}/scr"
	# HKCU User Shell Folders for PS1 script
	DESKTOP_HKCU="Desktop:${DESKTOP_DIR#*:}"
	DOCUMENTS_HKCU="Documents:${DOCUMENTS_DIR#*:}"
	DOWNLOADS_HKCU="Downloads:${DOWNLOADS_DIR#*:}"
	MUSIC_HKCU="Music:${MUSIC_DIR#*:}"
	PICTURES_HKCU="Pictures:${PICTURES_DIR#*:}"
	VIDEOS_HKCU="Videos:${VIDEOS_DIR#*:}"

	# Global vars
	export LOCAL_PS1_PATH="/tmp/powershell-gist.ps1"
	export GIST_MOVE_USER_DIRS="https://gist.githubusercontent.com/aubique/871ad87ef7a801d17942ca3974cd9909/raw/e7d2d14297f6b098972dae0213f0072716b6a186/mv-win11-user-dirs.ps1"
	export GIST_UPDATE_PATH="https://gist.githubusercontent.com/aubique/871ad87ef7a801d17942ca3974cd9909/raw/e7d2d14297f6b098972dae0213f0072716b6a186/update-win11-path.ps1"
	# Directories to link on $HOME
	export HOME_DIRS=($WINUSER_DIR $DEVELOPMENT_DIR $RECORD_DIR $DESKTOP_DIR $DOWNLOADS_DIR $DOCUMENTS_DIR $MUSIC_DIR $PICTURES_DIR $VIDEOS_DIR)
	export MISC_DIRS=($USRBIN_DIR $USRLOCALBIN_DIR $USRLIB_DIR $USRSHAREDOC_DIR $TMP_DIR $OPT_DIR $REC_DIR $SCR_DIR)
	export WIN_PATHS=($USRBIN_DIR $USRLOCALBIN_DIR)
	export HKCU_DIRS=($DESKTOP_HKCU $DOCUMENTS_HKCU $DOWNLOADS_HKCU $MUSIC_HKCU $PICTURES_HKCU $VIDEOS_HKCU)
}

is_powershell_initialized() {
	if [[ $PATH =~ (^|:)"/mnt/"[a-e]"/"WINDOWS|Windows"/System32/WindowsPowerShell/v1.0/"(:|$) ]]; then
		return
	fi

	echo
	echo "Powershell isn't initialized properly."
	echo "To proceed you should make sure that you can run Powershell.exe via WSL2."
	exit 1
}

create_dirs() {
	if [ "$RUN_MAKE_DIRS" == "1" ]; then
		echo -e "Update home and data directories:"

		for home_dir in "${HOME_DIRS[@]}"
		do
			TARGET_DIR="${home_dir#*:}"
			[[ -d "$TARGET_DIR" ]] || mkdir -p "$TARGET_DIR"
			readlink -e "$TARGET_DIR"
		done

		for misc_dir in "${MISC_DIRS[@]}"
		do
			TARGET_DIR="${misc_dir}"
			[[ -d "$TARGET_DIR" ]] || mkdir -p "$TARGET_DIR"
			readlink -e "$TARGET_DIR"
		done

		echo
	fi
}

link_dirs() {
	if [ "$RUN_LINK_DIRS" == "1" ]; then
		echo -e "Replace links for WSL2 home folder:"

		for dir in "${HOME_DIRS[@]}"
		do
			WSL_HOME_LINK="${dir%:*}"
			TARGET_DIR="${dir#*:}"

			# Verify whether the DIRECTORY, in which to create the links, exists or not, then create link
			if [ -d "$TARGET_DIR" ] && [ "$WSL_HOME_LINK" ]; then
				ln -fsT $TARGET_DIR $WSL_HOME_LINK
				ls -lahF $WSL_HOME_LINK
			fi
		done

		echo
	fi
}

dl_exec_ps1() {
	script_func_val=$($1 GET_URL_AND_PATH)

	# Break out unless allowed in interactive-mode
	[ -z "$script_func_val" ] && return
	#[ $? != "0" ] && return

	url_gist="${script_func_val%|*}"
	script_message="${script_func_val#*|}"

	# Output log message, download and assembly the script
	echo -e $script_message
	curl -Ss $url_gist -o $LOCAL_PS1_PATH
	($1)

	# Convert Dos2Unix before executing powershell script
	sed -i 's/$/\r/' $LOCAL_PS1_PATH

	# Run script under Powershell.exe
	PS_SCRIPT_PATH="$(wslpath -w $LOCAL_PS1_PATH)"
	powershell.exe -ExecutionPolicy Bypass -File "$PS_SCRIPT_PATH"

	# Clear script
	rm $LOCAL_PS1_PATH
	echo
}

update_path() {
	if [ -n "$1" ]; then
		URL=$GIST_UPDATE_PATH
		MESSAGE="Run powershell script to update PATH"

		if [ "$RUN_UPDATE_PATH" == "1" ]; then
			echo "$URL|$MESSAGE"
		else
			echo ""
		fi
		return
	fi

	for wsl_path in "${WIN_PATHS[@]}"
	do
		win_path="$(wslpath -w $wsl_path)"
		echo "Add-EnvPath PARAM_PATH User" \
		| sed -e "s/PARAM_PATH/${win_path//\\/\\\\}/g" \
		| tee -a $LOCAL_PS1_PATH \
		> /dev/null 2>&1
	done
}

move_user_shell_folders() {
	if [ -n "$1" ]; then
		URL=$GIST_MOVE_USER_DIRS
		MESSAGE="Run powershell script to move UserShell folders for Windows"

		if [ "$RUN_MOVE_USER_SHELL_FOLDERS" == "1" ]; then
			echo "$URL|$MESSAGE"
		else
			echo ""
		fi
		return
	fi

	for hkcu_dir in "${HKCU_DIRS[@]}"
	do
		registry_name="${hkcu_dir%:*}"
		#echo $registry_name
		wsl_user_folder_path="${hkcu_dir#*:}"
		#echo $wsl_user_folder_path
		win_user_folder_path="$(wslpath -w $wsl_user_folder_path)"
		#echo $win_user_folder_path

		echo 'UserShellFolder -UserFolder PARAM_USER_FOLDER -FolderPath PARAM_FOLDER_PATH -RemoveDesktopINI' \
		| sed -e "s/PARAM_USER_FOLDER/$registry_name/g" -e "s/PARAM_FOLDER_PATH/${win_user_folder_path//\\/\\\\}/g" \
		| tee -a $LOCAL_PS1_PATH \
		> /dev/null 2>&1
	done
}

main() {
	is_powershell_initialized
	ask_params
	set_params
	create_dirs
	link_dirs
	update_path
	dl_exec_ps1 update_path
	dl_exec_ps1 move_user_shell_folders
}


main
