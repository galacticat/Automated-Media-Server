#!/bin/bash
log_file="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )""/cleanup.log"
if [ ! -f "$log_file" ]; then
    touch "$log_file";
	chmod 777 "$log_file";
fi

log() {
	message="$1";
	echo $(date) "$message";
	echo $(date) "$message" >> "$log_file";
}

deleteFiles() {
	bool_string="$del_arg";
	if [ $bool_string=="true" ] || [ $bool_string=="True" ] || [ $bool_string=="0" ] || [ $bool_string -eq 0 ];	then
		# 0 = true
		return 0;
	elif [ $bool_string=="false" ] || [ $bool_string=="False" ] || [ $bool_string=="1" ] || [ $bool_string -eq 1 ];	then
		# 1 = false
		return 1;
	else
		log "$1 could not be parsed as a boolean";
	fi
}

# hasSubDirectories() {
#	subdircount=`find "$1" -maxdepth 1 -type d | wc -l;`
#	log "Sub Directory Count: $subdircount";
#	if [ $subdircount -eq 1 ]
#	then
#		# 0 = true
#		return 1;
#	else
#		# 1 = false
#		return 0;
#	fi
#}

cleanup() {
	root_dir="$1"
	rar_count=`find "$root_dir"*.rar | wc -l`
	if  [ $rar_count != 0 ] && [ -d "$root_dir" ]; then
		cd "$root_dir";
		for F in ./*; do
			if [[ $F == *.mkv ]] || [[ $F == *.avi ]] || [[ $F == *.mp4 ]]; then
				if  [ deleteFiles ]; then
					log "Removing: $F";
					rm "$F";
				else
					log "Would Normally Remove: $F";
				fi
			fi
		done
	else
		log "RAR Count: $rar_count - Command: find $1*.rar | wc -l";
	fi
}
# delete video files if found
del_arg="true";
# folder to look in
arg1="$sonarr_episodefile_sourcefolder/";
log "Checking: $arg1";
if [ -d "$arg1" ]; then
	if [ deleteFiles ]; then
		log "Delete Set: true";
	else
		log "Delete Set: false";
	fi
	cleanup "$arg1";
else
	log "Directory: $arg1 not found";
fi
