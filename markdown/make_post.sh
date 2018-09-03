#!/bin/bash

SITEDIR='../html'
TEMPLATEDIR='templates'

if [ -f "$1" ]; then
	HTML="`basename -s '.md' $1`.html"
	echo "$HTML"
	pandoc \
		--template="${TEMPLATEDIR}/post.html" \
		-c 'css/default.css' \
		--toc \
		--mathjax='https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-AMS_CHTML' \
		--email-obfuscation=javascript \
		-i "$1" \
		-o "${SITEDIR}/${HTML}"
fi

