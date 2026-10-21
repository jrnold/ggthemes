"""Measure field colour and flat ink colours in each WSJ chart image.

usage: measure.py IMG_DIR LIST OUT_DIR
Writes fields.csv (per image: field hex) and inks.csv (per image: flat-colour
clusters with pixel counts, chroma, hex).
"""

import csv
import sys
from collections import Counter
from pathlib import Path

import numpy as np
from PIL import Image
from skimage.color import lab2rgb, rgb2lab

img_dir, list_path, out_dir = map(Path, sys.argv[1:4])
files = [l.strip() for l in open(list_path) if l.strip()]


def hexof(rgb):
    return "#%02x%02x%02x" % tuple(int(round(v)) for v in rgb)


fields, inks = [], []
for f in files:
    im = np.asarray(Image.open(img_dir / f).convert("RGB")).astype(float)
    h, w, _ = im.shape
    # Field: modal colour (quantized to 2 levels/unit) of a 3px border.
    border = np.concatenate([im[:3].reshape(-1, 3), im[-3:].reshape(-1, 3), im[:, :3].reshape(-1, 3), im[:, -3:].reshape(-1, 3)])
    q = [tuple((p // 2).astype(int)) for p in border]
    mode = Counter(q).most_common(1)[0][0]
    sel = np.all((border // 2).astype(int) == mode, axis=1)
    field = border[sel].mean(axis=0)
    fields.append({"file": f, "field": hexof(field), "w": w, "h": h})

    # Flat pixels: 3x3 neighbourhood max channel range <= 12 (rejects JPEG edges, text).
    pad = np.pad(im, ((1, 1), (1, 1), (0, 0)), mode="edge")
    stack = np.stack([pad[dy : dy + h, dx : dx + w] for dy in range(3) for dx in range(3)])
    rng = (stack.max(axis=0) - stack.min(axis=0)).max(axis=2)
    flat = im[rng <= 12]
    if len(flat) == 0:
        continue
    lab = rgb2lab(flat[None] / 255)[0]
    # Drop pixels near the field colour.
    flab = rgb2lab(field[None, None] / 255)[0, 0]
    d = np.linalg.norm(lab - flab, axis=1)
    keep = d > 6
    lab = lab[keep]
    # Bin in Lab (4-unit cells) and keep bins with >= 15 px.
    bins = Counter(map(tuple, np.round(lab / 4).astype(int)))
    for b, n in bins.most_common():
        if n < 15:
            break
        c = np.array(b) * 4.0
        m = lab[np.all(np.round(lab / 4).astype(int) == b, axis=1)].mean(axis=0)
        rgb = np.clip(lab2rgb(m[None, None])[0, 0] * 255, 0, 255)
        inks.append({"file": f, "n": n, "L": round(m[0], 1), "a": round(m[1], 1), "b": round(m[2], 1),
                     "C": round(float(np.hypot(m[1], m[2])), 1), "hex": hexof(rgb)})

with open(out_dir / "fields.csv", "w", newline="") as fh:
    wr = csv.DictWriter(fh, fieldnames=["file", "field", "w", "h"]); wr.writeheader(); wr.writerows(fields)
with open(out_dir / "inks.csv", "w", newline="") as fh:
    wr = csv.DictWriter(fh, fieldnames=["file", "n", "L", "a", "b", "C", "hex"]); wr.writeheader(); wr.writerows(inks)
print(len(fields), len(inks))
