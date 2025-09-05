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
find "$FOLDER" -type f -name "*.svg" ! -name "*x.svg" | while read -r svgfile; do
  xbbfile="${svgfile%.svg}.xbb"
  pngfile="${svgfile%.svg}.png"
  pdffile="${svgfile%.svg}.pdf"
  if [ ! -f "$pdffile" ]; then
    echo "Missing PDF file for $svgfile"
    continue
  fi
  if [ ! -f "$pngfile" ]; then
    echo "Generating: $pngfile and svg"
    mutool draw -r 150 -c rgbalpha -o "$pngfile" "$pdffile"
    ebb -x "$pngfile"
#   else
#     echo "Skipping (exists): $xbbfile"
  fi
  if [ ! -f "$xbbfile" ]; then
    echo "Generating: $xbbfile"
    ebb -x "$pngfile"
#   else
#     echo "Skipping (exists): $xbbfile"
  fi
done
