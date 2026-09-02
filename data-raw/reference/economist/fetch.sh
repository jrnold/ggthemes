#!/bin/sh
# Re-download The Economist visual styleguide and render the pages the
# theme is matched against (see SOURCES.md). Requires poppler
# (pdftotext) and ghostscript.
set -eu
cd "$(dirname "$0")"
url="https://sa.ipaa.org.au/wp-content/uploads/2026/02/Economist-CHARTstyleguide_20170505.pdf"
curl -sL "$url" -o styleguide.pdf
pdftotext -layout styleguide.pdf styleguide.txt
for p in 3 5 6 7 11 12 25; do
    gs -dNOPAUSE -dBATCH -sDEVICE=png16m -r110 \
       -dFirstPage="$p" -dLastPage="$p" \
       -sOutputFile="page$p.png" styleguide.pdf >/dev/null
done
