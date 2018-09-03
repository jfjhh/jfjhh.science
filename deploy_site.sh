#!/bin/bash

printf "\033[0;32m[[=== Deploying Site ===]]\033[0;34m\n"

# Make it slightly harder for scrapers to get internal information.
DEPLOY='c2Z0cCAtbyBVc2VyPXN0cmlmZmEgc2Z0cC5yZWVkLmVkdSA8PDwgJ3B1dCAtcmYgaHRtbCcK'
DEPLOY_CMD="`base64 -d <<< $DEPLOY`"
printf "\033[0;35m${DEPLOY_CMD}\033[0;34m\n"
sh -c "$DEPLOY_CMD"

printf "\033[0;32m[[=== Site Deployed. ===]]\033[0m\n"

