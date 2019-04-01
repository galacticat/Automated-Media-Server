#!/bin/bash
delete_files=$1
log_on="false";
if [ -z "$sonarr_episodefile_sourcefolder"  ]; then
  file_dir=$2
  log_on="false";
  echo "Running on:" $(date);
  echo "Log:" $log_on;
else
  file_dir=$sonarr_episodefile_sourcefolder
  log_on="true";
  echo "Running on:" $(date);
  echo "Running for:" $sonarr_episodefile_sourcepath;
fi
if [ -d "${file_dir}" ]; then
 if [ $log_on == "true" ]; then
  echo $(date) "Checking:" $file_dir;
 else
  echo "Checking:" $file_dir;
 fi
 if [ -z $delete_files ]; then
  read -p "Do you want to delete files found? " -n 1 -r
  echo
 fi
 for D in "$file_dir"/*/; do
  for R in "${D}"*; do
   if [[ $R == *.rar ]]; then
    for F in "${D}"*; do
     if [[ $F == *.mkv ]] || [[ $F == *.avi ]] || [[ $F == *.mp4 ]]; then
      if [ $log_on == "true" ]; then
       echo $(date) "RAR Found:" $R >> cleanup.log;
       echo $(date) "File Found:" $F >> cleanup.log;
      else
       echo "RAR Found:" $R;
       echo "File Found:" $F;
      fi
      if [ $delete_files == "true" ] || [[ $REPLY =~ ^[Yy]$ ]]; then
       if [ $log_on == "true" ]; then
        echo $(date) "Removing:" $F >> cleanup.log;
       else
        echo "Removing:" $F;
       fi
       rm "${F}";
      fi
      echo
     fi
    done
   fi
  done
 done
else
 if [ $log_on == "true" ]; then
  echo $(date) $file_dir "is not found" >> cleanup.log;
 else
  echo $file_dir "is not found";
 fi
fi
