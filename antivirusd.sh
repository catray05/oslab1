#!/bin/bash

dir="$1"
malicious_dir="$2"
interval_secs="$3"

ls -l "$dir" > directory-info.last
while true
do
	ls -l "$dir" > directory-info.new
	if ! cmp directory-info.new directory-info.last
	then
		cp directory-info.new directory-info.last
	else
		sleep "$interval_secs"
	fi
