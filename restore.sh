#!/bin/bash

dir="$1"
malicious_dir="$2"

if [ -z "$(ls "$malicious_dir")" ]; then
	echo "No malicious files to review."
else
	i=1
	echo "Choose a file:"
	for file in "$malicious_dir"/*;do
		echo "$i: $file"
		((i++))
	done
	read choice
fi
