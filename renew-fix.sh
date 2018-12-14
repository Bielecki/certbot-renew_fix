#!/bin/bash
if ! [ "${UID}" -eq 0 ]; then
	echo "Unfortunately - this script modifies several system files, so you have to run it as root"
	echo "Please run $0 with sudo"
	exit 1
fi
if [ -n "$2" ]; then
	echo "This script takes only one site at once. Remove second parameter please"
	exit 1
fi
	if [ -z "$1" ]; then
		echo "You need to specify site to fix"
		echo "Usage: $0 <site.com>"
		exit 1
	else
		if [ -d  /etc/letsencrypt/live/"$1" ] && [ -d /etc/letsencrypt/archive/"$1" ]; then
		echo "Renaming old files... Press ^C in next 3 seconds to stop"
		sleep 3
		rename 's/.pem/.pem.old/' /etc/letsencrypt/live/"$1"/*
		echo "Renamed"
		echo "Creating links... Press ^C in next 3 seconds to stop"
		sleep 3
		ln -s /etc/letsencrypt/archive/"$1"/cert1.pem /etc/letsencrypt/live/"$1"/cert.pem
		ln -s /etc/letsencrypt/archive/"$1"/chain1.pem /etc/letsencrypt/live/"$1"/chain.pem
		ln -s /etc/letsencrypt/archive/"$1"/fullchain1.pem /etc/letsencrypt/live/"$1"/fullchain.pem
		ln -s /etc/letsencrypt/archive/"$1"/privkey1.pem /etc/letsencrypt/live/"$1"/privkey.pem
		echo "Done"
	else
		echo "Directory doesn't exist in /etc/letsencrypt/live/ or /etc/letsencrypt/archive/"
		echo "Check parameter"
		exit 1
	fi
fi
