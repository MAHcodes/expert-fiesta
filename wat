#!/usr/bin/env bash

echo $1 | entr -p ./gen $1 &

./gen $1

zathura "./pdfs/$(basename $1 .md).pdf"

pkill -f "entr -p ./gen $1"
