#!/bin/bash
# Usage: ./add-xbb.sh /path/to/folder

FOLDER="$1"

if [ -z "$FOLDER" ]; then
  echo "Usage: $0 <folder>"
  exit 1
fi

if ! command -v ebb >/dev/null 2>&1; then
  echo "Error: ebb not found in PATH"
  exit 1
fi

# Find all .svg files in subfolders and process them if .xbb is missing
find "$FOLDER" -type f -name "*.png" | while read -r svgfile; do
  xbbfile="${svgfile%.png}.xbb"
  if [ ! -f "$xbbfile" ]; then
    echo "Generating: $xbbfile"
    ebb -x "$svgfile"
#   else
#     echo "Skipping (exists): $xbbfile"
  fi
done
