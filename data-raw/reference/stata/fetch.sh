#!/bin/sh
# Re-download the Stata reference graphs (see SOURCES.md).
set -eu
cd "$(dirname "$0")"
base="https://www.stata.com/features/overview/i"
for i in 1 2 3 4; do
    curl -sL "$base/scheme${i}_stcolor.svg" -o "stcolor$i.svg"
    rsvg-convert -b white -z 1.4 -o "stcolor$i.png" "stcolor$i.svg"
done
curl -sL "$base/scheme5_stcolor.svg" -o "s2color1.svg"
rsvg-convert -b white -z 1.4 -o "s2color1.png" "s2color1.svg"
