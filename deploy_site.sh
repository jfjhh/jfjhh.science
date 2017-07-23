#!/bin/bash

printf "\033[0;32m[[=== Deploying Site ===]]\033[0;34m\n"

# Load ssh key using keychain.
printf "\033[0;36m=== Get SSH Key ===\033[0;34m\n"
[ -z "$HOSTNAME" ] && HOSTNAME=`uname -n`
source "${HOME}/.keychain/${HOSTNAME}-sh" 2> /dev/null


# Only deploy if a SSH key is available.
if `ssh-add -l 2> /dev/null | tee /dev/stderr | grep -q id_rsa`; then
	# RSync the files.
	printf "\033[0;36m=== RSync to Server ===\033[0;34m\n"
	rsync \
		-avcz \
		--delete-delay \
		-e ssh \
		html \
		'bullet@jfjhh.science:/var/www/'
else
	printf "\033[0;31m[[=== No SSH Key Available! ===]]\033[0m\n"
	exit 1
fi

printf "\033[0;32m[[=== Site Deployed. ===]]\033[0m\n"

