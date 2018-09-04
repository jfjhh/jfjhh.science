#!/bin/bash

printf "\033[0;32m[[=== Deploying Site ===]]\033[0;34m\n"

ARG="$1"

# Make it slightly harder for scrapers to get internal information.
DEPLOY='c2Z0cCAtb1VzZXI9c3RyaWZmYSBzZnRwLnJlZWQuZWR1Cg=='
DEPLOY_CMD="`base64 -d <<< $DEPLOY`"
printf "\033[0;35m${DEPLOY_CMD}\033[0;34m\n"

MANIFEST="manifest.txt"

if [[ "$ARG" = "force" ]]; then
	echo 'put -rf html';
else
	rm -f "$MANIFEST";
	echo "get html/$MANIFEST html/$MANIFEST";
	find html -type f -print0 \
		| xargs -0 md5sum -b > "$MANIFEST";
	while [ ! -f "html/$MANIFEST" ]; do
		sleep 0.5;
	done;
	cat "$MANIFEST" "html/$MANIFEST" \
		| sort \
		| uniq -u\
		| cut --complement -d '*' -f -1 \
		| sort -u \
		| awk '{print "put -f " $1 " html";}';
	echo "put $MANIFEST html";
fi | tee sftp.log | sh -c "$DEPLOY_CMD"

printf "\033[0;32m[[=== Site Deployed. ===]]\033[0m\n"

