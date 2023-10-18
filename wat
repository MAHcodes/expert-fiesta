#!/usr/bin/env bash

pkill entr

echo $1 | entr -p ./gen $1 &

./gen $1

if [ -f "./pdfs/$(basename $1 .md).pdf" ]; then
  zathura "./pdfs/$(basename $1 .md).pdf"
fi
