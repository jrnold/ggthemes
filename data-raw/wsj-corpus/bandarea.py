"""Share of image area within dE<4 of the darker-tint band colour for the image's field. usage: bandarea.py IMG_DIR FIELDS FIELDCLASS OUT"""
import csv, sys
import numpy as np
from PIL import Image
from skimage.color import rgb2lab
img_dir, fields, fclass, out = sys.argv[1:5]
cls = dict(l.split() for l in open(fclass))
rows = list(csv.DictReader(open(fields)))
res = []
for r in rows:
    im = np.asarray(Image.open(f"{img_dir}/{r['file']}").convert("RGB")) / 255
    lab = rgb2lab(im).reshape(-1, 3)
    fld = rgb2lab(np.array([[[int(r['field'][i:i+2], 16) / 255 for i in (1, 3, 5)]]]))[0, 0]
    # candidate band: pixels 3-12 L darker than the field with near field hue (dE in a,b < 5)
    dL = fld[0] - lab[:, 0]
    dab = np.hypot(lab[:, 1] - fld[1], lab[:, 2] - fld[2])
    cand = (dL > 2.5) & (dL < 12) & (dab < 9)
    share = cand.mean()
    hexv = ""
    if cand.sum() > 50:
        m = im.reshape(-1, 3)[cand].mean(axis=0) * 255
        hexv = "#%02x%02x%02x" % tuple(int(v) for v in m)
    res.append({"file": r["file"], "field": cls[r["file"]], "band_share": round(float(share), 3), "band_hex": hexv})
with open(out, "w", newline="") as fh:
    wr = csv.DictWriter(fh, fieldnames=list(res[0])); wr.writeheader(); wr.writerows(res)
