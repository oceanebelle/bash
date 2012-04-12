#!/bin/bash

ARG_DIR=""
ARG_REG=""
ARG_VERBOSE=0
ARG_VALUE=""

# Abstract
# The purpose of this script is to rename all files within a specifed folder by replacing the matching string within the filename with either the folder name or a provided replacement string.

# Problem Description
# This came about when I had loads of scans but can only be bothered to name the folder to which the images belong but not each invividual scans. ie a directory or passport scans. You could argue that this is a glorified prefixer. :P

#-------------------------------------------------------

show_usage () {
	echo  "USAGE: Required parameters"
	echo  " -d <Parent folder Path>"
	echo  " -r Regular expression used to match the part of the filename to replace"
	echo  " -v Verbose logging during folder processing (optional)"
	echo  " -n Value to replace the match instead of the parent folder name (optional)"

	return 1
}

read_args () {
	echo "Arguments: $@"
        while : 
 	do
		case "$1" in
			-d | --directory)
				ARG_DIR="$2"
				shift 2
				;;
			-r | --regex)
				ARG_REG="$2"
				shift 2
				;;
			-n | --newval)
				ARG_VALUE="$2"
				shift 2
				;;
			-v | --verbose)
				ARG_VERBOSE=1
				shift 1
				;;
			*)
				break
		esac
	done
}

process_folder () {
	target_parent=`cd "$1" ; pwd`
	if [ $ARG_VERBOSE -eq 1 ] 
	then
		echo "FOLDER: $target_parent"
	fi
	cd $target_parent

	if [ -z $ARG_VALUE ]
	then
		new_name=`basename $target_parent`
	else
		new_name="$ARG_VALUE"
	fi

	# process only the files in this folder and not child folders
	for target_file in `find . -type f -maxdepth 1 -mindepth 1 -print 2>/dev/null` 	
	do
		new_file_name=`echo $target_file | sed "s/$ARG_REG/${new_name}_/g"`
		if [ $target_file != $new_file_name ]
		then
			if [ $ARG_VERBOSE -eq 1 ] 
			then
				echo "Renaming FILE: $target_file -> $new_file_name"
			fi
			mv $target_file $new_file_name
		fi
	done
}

start_processing () {
	# todo validate parameters

        read_args $@

	local d="$ARG_DIR"	

	if [[ -e $d && -d $d && -r $d && -w $d ]]
	then
		echo "Folder verified"
	else
		echo "Target folder is invalid. "
		echo "Please check that the folder \"$ARG_DIR\" exists and you have r+w permissions"
		return 1
	fi

	# List all folders within the root folder
	CURR_DIR=`pwd`
	cd $ARG_DIR
	
	echo "-----------------------------------"
	echo "Converting files in directory : \"$ARG_DIR\""
	echo "Using file matching pattern   : \"$ARG_REG\""
	
	for target_folder in `find . -type d -print 2>/dev/null`
	do
		# NB: comment if expr to exclude processing the parent directory
		#if [[ !($target_folder -ef $ARG_DIR) ]]
		#then
			process_folder $target_folder
			cd "$ARG_DIR"
		#fi
	done

	cd $CURR_DIR
	return 0
}



#-------------------------------------------------------

ARGS_EXPECTED=4
ARGS_PROVIDED=$#

if [ $ARGS_PROVIDED -lt $ARGS_EXPECTED ] 
then
	show_usage $ARGS_PROVIDED
else
	start_processing $@
fi

# returns the set status of the last executing function
exit $?


