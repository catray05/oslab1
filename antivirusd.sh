#!/bin/bash

dir="$1"
malicious_dir="$2"
interval_secs="$3"

scan(){
	for file in "$1"/*;do
		if grep -Fq  "$file" whitelist
		then
			continue
		fi
		if [[ "$file" == *.exe || "$file" == *.bat || "$file" == *.vbs || "$file" == *.scr || "$file" == *.ps1 ]] || grep -Eiq 'virus|trojan|malware|worm|ransomware' "$file"
		then
			echo "$file is malicious and it is DELETED"
			cp "$file" "$malicious_dir"
			rm "$file"
		fi
	done
}

scan "$dir"
ls -l "$dir" > directory-info.last
while true
do
	ls -l "$dir" > directory-info.new
	if ! cmp directory-info.new directory-info.last
	then
		scan "$dir"
		ls -l "$dir" > directory-info.last
	else
		sleep "$interval_secs"
	fi
done
