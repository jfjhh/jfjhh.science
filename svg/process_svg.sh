#!/bin/bash

SITEDIR='../html'
OUTDIR="${SITEDIR}/img"

# Process a SVG file into a drawing-sized SVG and fallback PNG.
function process_svg()
{
	printf "[$1]\n"
	RESIZED="${OUTDIR}/`basename -s .svg ${1}`"
	OUTSVG="${RESIZED}.svg"
	OUTPNG="${RESIZED}_fallback.png"
	printf "SVG Clip: %s\n" "$OUTSVG"
	./svgclip.py "$1" -o "$OUTSVG"
	printf "SVG->PNG: %s\n" "$OUTPNG"
	inkscape -z -D -e "$OUTPNG" "$OUTSVG"
	printf "\n"
}

printf "\033[0;36m=== Processing SVG ===\033[0;34m\n"

# Clean old SVG images.
rm -v ${OUTDIR}/*.svg ${OUTDIR}/*_fallback.png
printf "\n"

# Run SVG processing in parallel.
export OUTDIR
export -f process_svg
parallel --will-cite --env OUTDIR -j0 process_svg ::: *.svg

