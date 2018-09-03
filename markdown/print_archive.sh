#!/bin/bash

POSTDIR=posts

# Archive file header.
cat <<EOF
---
title: 'Archive'
author:
- Alex Striff
date: `date -I`
---

All Posts
=========

Newer Posts First
-----------------

EOF

function archive_line()
{
	cat <<-EOF
	- [`head $1 | grep '^title: ' | head -1 | \
		sed "s%^.*[\"']\(.*\)[\"']%\1%"`](`basename -s .md \
		$1`.html) (*`head $1 | grep '^date: ' | head -1 | \
		sed "s%^date: %%"`*).
	EOF
}

# Archive file entries.
cd "$POSTDIR"
export -f archive_line
ls -t *.md | parallel --will-cite -j0 -k archive_line
cd ..

# Archive file footer.
cat <<EOF

EOF

