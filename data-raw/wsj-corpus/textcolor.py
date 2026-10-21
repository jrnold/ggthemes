"""Measure the darkness of the type in the title, subtitle and source lines of each WSJ chart.

usage: textcolor.py IMG_DIR LIST OUT_CSV

Type pixels are neutral (channel range under 30) and at least 60 levels darker than the field. Glyph cores of small
type do not reach the ink's full value, so the darkest 5% of a region's type pixels stand for its ink: about 20 to 40
for black type, and well above that for gray.
"""

import csv
import sys
from pathlib import Path

import numpy as np
from PIL import Image

img_dir, list_path, out_csv = Path(sys.argv[1]), Path(sys.argv[2]), Path(sys.argv[3])
files = [l.strip() for l in open(list_path) if l.strip()]


def type_rows(im, field_lum):
    lum = im.mean(axis=2)
    neutral = (im.max(axis=2) - im.min(axis=2)) < 30
    return (lum < field_lum - 60) & neutral, lum


def ink(mask, lum):
    v = lum[mask]
    if v.size < 15:
        return ""
    return round(float(np.percentile(v, 5)), 1)


rows = []
for f in files:
    im = np.asarray(Image.open(img_dir / f).convert("RGB")).astype(float)
    h, w, _ = im.shape
    field_lum = np.median(np.concatenate([im[:3].reshape(-1, 3), im[-3:].reshape(-1, 3)]), axis=0).mean()
    mask, lum = type_rows(im, field_lum)
    # The title is the first block of type rows from the top; the source block the last from the bottom.
    has = mask.sum(axis=1) > 2
    idx = np.flatnonzero(has)
    top = np.zeros_like(mask)
    sub = np.zeros_like(mask)
    bottom = np.zeros_like(mask)
    if idx.size:
        # The title is the first block of type rows, ending at the first gap of 3 rows; the subtitle is the next
        # block, its first line only (8 rows), since a second block may already be the top y label.
        i = idx[0]
        while i < h and has[i:i + 3].any():
            i += 1
        top[idx[0]:i] = mask[idx[0]:i]
        nxt = idx[idx > i]
        if nxt.size:
            sub[nxt[0]:nxt[0] + 8] = mask[nxt[0]:nxt[0] + 8]
        b = h - int(0.10 * h)
        bottom[b:] = mask[b:]
    rows.append({"file": f, "title_ink": ink(top, lum), "subtitle_ink": ink(sub, lum), "source_ink": ink(bottom, lum)})

with open(out_csv, "w", newline="") as fh:
    wr = csv.DictWriter(fh, fieldnames=list(rows[0]))
    wr.writeheader()
    wr.writerows(rows)
