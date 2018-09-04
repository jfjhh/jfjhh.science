#!/bin/bash

printf "\033[0;32m[[=== Deploying Site ===]]\033[0;34m\n"

# Make it slightly harder for scrapers to get internal information.
DEPLOY='c2Z0cCAtb1VzZXI9c3RyaWZmYSBzZnRwLnJlZWQuZWR1Cg=='
DEPLOY_CMD="`base64 -d <<< $DEPLOY`"
printf "\033[0;35m${DEPLOY_CMD}\033[0;34m\n"

MANIFEST="manifest.txt"

(
rm -f "$MANIFEST";
echo "get html/$MANIFEST";
sleep 0.2
while [ ! -f "$MANIFEST" ]; do
	sleep 0.5;
done;
md5sum -c --quiet "$MANIFEST" \
	| cut --complement -d : -f 2- \
	| awk '{print "put -f " $1;}';
find html -type f -print0 \
	| xargs -0 md5sum -b > "$MANIFEST";
echo "put $MANIFEST html";
) | tee sftp.log | sh -c "$DEPLOY_CMD"

printf "\033[0;32m[[=== Site Deployed. ===]]\033[0m\n"

