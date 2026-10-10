#!/bin/bash

dir="$1"
malicious_dir="$2"

while true;do
	if [ -z "$(ls $malicious_dir)" ]; then
		echo "No malicious files to review."
		break
	fi
	files=("$malicious_dir"/*)
	i=1
	echo "Choose a file:"
	for file in "${files[@]}";do
		echo "$i: $file"
		((i++))
	done
	read choice
	selected="${files[$((choice-1))]}"
	echo "For $selected:"
	echo "1: Restore this file back into dir (it was a false positive)"
	echo "2: Permanently delete this file from malicious_dir (it was genuinely malicious)"
	echo "3: Go back"
	read choice
	case "$choice" in
		1)
			mv "$selected" "$dir"
			echo "$selected" >> whitelist
			echo "Restored $selected to $dir."
			;;
		2)
			rm "$selected"
			echo "$selected permanently deleted."
			;;
		3)
			continue
			;;
	esac
done

