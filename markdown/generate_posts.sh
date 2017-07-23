#!/bin/bash

SITEDIR='../html'
RUNDIR="`pwd`"
MDDIRS='. ./posts'

printf "\033[0;36m=== Generating Posts ===\033[0;34m\n"

# Clean old posts.
rm -v ${SITEDIR}/*.html

# Make the index something more interesting than an empty file.
printf "\n[Index]\n"
${RUNDIR}/make_index.sh
cd ${RUNDIR}

# Generate the archive of posts.
printf "\n[Archive]\n"
${RUNDIR}/make_archive.sh
cd ${RUNDIR}

# Run post generation in parallel.
printf "\n[Posts]\n"
find $MDDIRS -type f -name '*.md' -print0 | \
	parallel --will-cite -0 -j0 ./make_post.sh

printf "\n"

