#!/bin/bash

<<<<<<< HEAD:Linux/rename.sh
#default directories
TV_defaultdir=("/home/testdir" "/home/testdir2")
Film_defaultdir=("/home/testdir" "/home/testdir2")
=======

>>>>>>> 9b281ed (added auto chmod and chown and options):renametool.sh

#Define scripts directory
script_dir="$(cd "$(dirname "$0")" && pwd)"

source $script_dir/options.sh

#Help
Display_help()
{
	echo "TPDB to Plex renamer options"
	echo "Usage: $0 [OPTIONS] [ARGUMENTS]"
	echo
	echo
	echo "Options:"
	echo
	echo "[-h|--help]"
	echo
	echo
	echo "[-t|-tv]	[TV Directory]		[Second TV Directory...]"
	echo "		Specify the root TV directory(s) to rename"
	echo "		Leave empty to rename files in current directory"
	echo
	echo "[-f|-film]	[Film Directory]	[Second Film Directory...]"
	echo "		Specify the root Film directory(s) to rename"
	echo "		Leave empty to rename files in current directory"
	echo
	echo "[-d|-default]"
	echo "		Rename both TV and Film default directory(s)"
	echo
	echo "[-dt|-defaulttv]"
	echo "		Rename TV default directory(s)"
	echo
	echo "[-df|-defaultfilm]"
	echo "		Rename Film default directory(s)"
	echo
	echo
}

#Execute rename scripts
execute_rename()
{
	#Rename TV Dir
	if [ "$1" = "TV" ]; then
		"$script_dir/renametv.sh" "$2"
		if [ "$2" = "./" ]; then
			echo "Current directory renamed."
		else
			echo "$2 renamed."
		fi
	elif [ "$1" = "Film" ]; then
	#Rename Film Dir
		"$script_dir/renamefilms.sh" "$2"
		if [ "$2" = "./" ]; then
			echo "Current directory renamed."
		else
			echo "$2 renamed."
		fi
	else
		echo "Error: Unknown directory type."
	fi
}


#Directory array rename function
rename_array()
{
	#dir_type true=tv false=films
	local dir_type=$1
	shift
	local input_array=("$@")
	#Post process array
	pp_array=($(echo "${input_array[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
	#Check if no directory is specified
	if [ ${#pp_array[@]} -eq 0 ];then
		echo "Renaming from current directory."
		execute_rename "$dir_type" "./"
	else
		#Rename every directory in array
		for dir in "${pp_array[@]}"; do
			if [ -e "$dir" ]; then
				#Check if directory is valid
				if [ -d "$dir" ]; then
					echo "Renaming $dir"
					execute_rename "$dir_type" "$dir"
				else
					echo "$dir is not a valid directory."
				fi
			else
				echo "$dir is not a valid directory."
			fi
		done
	fi
}
		
#check for no options
if [ "$#" -eq 0 ]; then
	echo "Unknown usage: use -h or --help"
	exit 1
fi

#check options
while [[ "$#" -gt 0 ]]; do
	case $1 in
		-h|--help)
			Display_help
			exit 1
			;;
		-t|-tv)
			shift
			tv_used=true
			while [[ "$1" != -* && "$#" -gt 0 ]]; do
				tv_dir+=("$1")
				shift
			done
			;;
		-f|-film)
			shift
			film_used=true
			while [[ "$1" != -* && "$#" -gt 0 ]]; do
				film_dir+=("$1")
				shift
			done
			;;
		-d|-default)
			tv_used=true
			film_used=true
			tv_dir=(${TV_defaultdir[@]})
			film_dir=(${Film_defaultdir[@]})
			shift
			;;
		-dt|-defaulttv)
			tv_used=true
			tv_dir=(${TV_defaultdir[@]})
			shift
			;;
		-df|-defaultfilm)
			film_used=true
			film_dir=(${Film_defaultdir[@]})
			shift
			;;
		*)
			echo "Unknown usage: use -h or --help"
			exit 1
			;;
	esac
	shift
done

#directory permissions
dir_perms()
{
	chmod -R $2 $1
	chown -R $3 $1
}

#Rename TV directories
if [ "$tv_used" = true ]; then
	echo "Renaming TV Directories"
	rename_array "TV" "${tv_dir[@]}"
	echo "Applying TV Directory Permissions"
	dir_perms "${tv_dir[@]}" "$TV_chmod" "$TV_chown"
fi

#Rename Film directories
if [ "$film_used" = true ]; then
	echo "Renaming Film Directories"
	rename_array "Film" "${film_dir[@]}"
	echo "Applying Film Directory Permissions"
	dir_perms "${film_dir[@]}" "$Film_chmod" "$Film_chown"
fi