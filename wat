#!/usr/bin/env bash

source "./env"

echo $1 | entr -p ./gen $1 &

./gen $1

zathura "$OUTPUT_PATH$(basename $1 .md).pdf"
