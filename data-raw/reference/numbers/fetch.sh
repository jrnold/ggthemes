#!/bin/sh
# Extract the Apple Numbers chart palettes and chart style defaults from the
# installed application bundle, persisting them as plain files for
# data-raw/numbers_palettes.R to read (see SOURCES.md).
#
# Stage 1 of 2. Nothing downstream reads /Applications directly, so the
# extracted files can be re-run and diffed without Numbers installed.
set -eu

cd "$(dirname "$0")"

app="${NUMBERS_APP:-/Applications/Numbers.app}"
res="$app/Contents/Resources"

if [ ! -d "$res" ]; then
    echo "Numbers not found at $app" >&2
    echo "Install Numbers, or set NUMBERS_APP to its location." >&2
    exit 1
fi

mkdir -p plists

# Record the version these files came from, so SOURCES.md can be checked
# against what is actually on disk.
/usr/bin/defaults read "$app/Contents/Info.plist" CFBundleShortVersionString \
    > VERSION

# The 12 chart palettes. plutil converts each plist to JSON so that the R
# stage can read them with jsonlite rather than parsing binary plists.
for f in "$res"/*.sfccolor.plist; do
    name="$(basename "$f" .sfccolor.plist)"
    /usr/bin/plutil -convert json -o "plists/$name.json" "$f"
done

# Chart style defaults (gridlines, axis borders, tick marks, legend).
/usr/bin/gunzip -c "$res/SDBGDefaultThemeStyleSheet.xml.gz" > chart-style.xml

echo "Extracted $(ls plists | wc -l | tr -d ' ') palettes from Numbers $(cat VERSION)"
