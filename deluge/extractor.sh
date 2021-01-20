#!/usr/bin/env bash
# Run with Execute plugin
# http://dev.deluge-torrent.org/wiki/Plugins/Execute
# On Event "Torrent Complete"
# It will extract the archive into a new folder "extracted"
# in the base of the torrent
# Useful if you want to keep seeding.
# This is similar to the script on the above page, but cleaner directory layout, suits plex and Kodi.
formats=(zip rar)
commands=([zip]="unzip -u" [rar]="unrar -o- e")
log_path="/config/scripts/extractor.log"
extraction_subdir='extracted'
torrentid=$1
torrentname=$2
torrentpath=$3

log()
{
    dt=$(date '+%m/%d/%Y %H:%M:%S')
    echo "[$dt] $@" >> ${log_path}
    #logger -t deluge-extractarchives "$@"
}

cd "${torrentpath}"
for format in "${formats[@]}"; do
    while read file; do
        log "Torrent complete: ${torrentname}"
        log "Torrent Path: ${torrentpath}"
        log "Torrent ID: ${torrentid}"
        log "Extracting \"$file\""
        cd "$(dirname "$file")"
        file=$(basename "$file")
        # if extraction_subdir is not empty, extract to subdirectory
        #if [ !  -d "$extraction_subdir" ] ; then
            #echo "I don't exist"
            #echo "${torrentpath}"
            #echo "${torrentname}"
            #mkdir "$extraction_subdir"
            #cd "$extraction_subdir"
            file="${torrentpath}/"${torrentname}"/$file"
            ${commands[$format]} "$file"
        #else
            #echo "exists!"
        #fi

        #${commands[$format]} "$file"
    done < <(find "$torrentpath/$torrentname" -iname "*.${format}" )
done
