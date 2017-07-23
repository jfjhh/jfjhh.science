#!/bin/bash

POSTDIR='posts'

echo 'index.md'
cp "`ls -t ${POSTDIR}/*.md | head -1`" 'index.md'

