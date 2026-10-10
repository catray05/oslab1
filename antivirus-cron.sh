#!/bin/bash

dir="$1"
malicious_dir="$2"

scan(){
	for file in "$dir"/*;do
		if [[ "$file" == *.exe || "$file" == *.bat || "$file" == *.vbs || "$file" == *.scr || "$file" == *.ps1 ]] || grep -Ei -w 'virus|trojan|malware|worm|ransomware' "$file"
		then
			echo "$file is malicious and it is DELETED"
			cp "$file" "$malicious_dir"
			rm "$file"
		fi
	done
}

scan
