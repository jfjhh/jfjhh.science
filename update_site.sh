#!/bin/bash

RUNDIR="`pwd`"

printf "\033[0;32m[[=== Updating Site ===]]\033[0;34m\n\n"

# Generate posts from markdown.
cd "${RUNDIR}/markdown"
./generate_posts.sh

# Generate resized SVG and fallback PNG files.
cd "${RUNDIR}/svg"
./process_svg.sh

cd "${RUNDIR}"

printf "\033[0;32m[[=== Site Updated. ===]]\033[0m\n"

