"""Compare the colour of direct series labels with the colour of their lines.

usage: label_colors.py IMG_DIR LIST OUT_CSV

For each chart, chromatic pixels (C* > 15) are binned by hue (30-degree bins). Within a hue bin, connected components
are split into glyphs (bounding box at most 12 px tall and 14 px wide: letters of a label) and lines (at least 30 px
wide: series). The "core" colour of each set is the mean of its darkest third of pixels in L*, which discounts the
anti-aliased edges that thin strokes share. A hue bin is reported when it has at least 40 glyph pixels and 40 line
pixels. Black and gray series have no hue, so they are not measured.
"""

import csv
import sys

import numpy as np
from PIL import Image
from scipy import ndimage
from skimage.color import lab2rgb, rgb2lab

img_dir, list_path, out_path = sys.argv[1:4]
files = [l.strip() for l in open(list_path) if l.strip()]
rows = []
for f in files:
    im = np.asarray(Image.open(f"{img_dir}/{f}").convert("RGB")) / 255
    lab = rgb2lab(im)
    chroma = np.hypot(lab[..., 1], lab[..., 2])
    hue = (np.degrees(np.arctan2(lab[..., 2], lab[..., 1])) + 360) % 360
    chromatic = chroma > 15
    for lo in range(0, 360, 30):
        mask = chromatic & (hue >= lo) & (hue < lo + 30)
        if mask.sum() < 80:
            continue
        labels, n = ndimage.label(mask, structure=np.ones((3, 3)))
        glyph = np.zeros_like(mask)
        line = np.zeros_like(mask)
        for i, sl in enumerate(ndimage.find_objects(labels), start=1):
            h = sl[0].stop - sl[0].start
            w = sl[1].stop - sl[1].start
            comp = labels[sl] == i
            if h <= 12 and w <= 14 and comp.sum() >= 4:
                glyph[sl] |= comp
            elif w >= 30:
                line[sl] |= comp
        if glyph.sum() < 40 or line.sum() < 40:
            continue

        def core(m):
            px = lab[m]
            px = px[px[:, 0] <= np.quantile(px[:, 0], 1 / 3)]
            return px.mean(axis=0)

        g, l = core(glyph), core(line)
        hexes = ["#%02x%02x%02x" % tuple(int(round(v * 255)) for v in np.clip(lab2rgb(c[None, None])[0, 0], 0, 1))
                 for c in (g, l)]
        rows.append({
            "file": f, "hue_bin": lo, "glyph_px": int(glyph.sum()), "line_px": int(line.sum()),
            "glyph_L": round(g[0], 1), "line_L": round(l[0], 1), "dL": round(g[0] - l[0], 1),
            "glyph_C": round(float(np.hypot(g[1], g[2])), 1), "line_C": round(float(np.hypot(l[1], l[2])), 1),
            "glyph_hex": hexes[0], "line_hex": hexes[1],
        })
with open(out_path, "w", newline="") as fh:
    wr = csv.DictWriter(fh, fieldnames=list(rows[0]))
    wr.writeheader()
    wr.writerows(rows)
print(len(rows), "hue groups")
