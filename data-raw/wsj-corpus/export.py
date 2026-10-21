"""Export the WSJ corpus readings and measurements for the style-guide article.

usage: python3 export.py MANIFEST_TSV OUT_DIR

Inputs (this directory):
  kept_sorted.txt       the 386 charts kept (corpus chart-list.txt minus images marked "remove")
  fields.csv            measure.py: field colour of each chart
  fieldclass.txt        classify_fields.py: field colour class of each chart
  inks.csv              measure.py: flat colour clusters of each chart
  bands.csv             bandarea.py: share of each chart in the band tint of its field
  readings-pass1.jsonl  first reading of every chart by a Claude subagent (titles, chart types, colours, ...)
  readings-pass2.jsonl  second reading of every chart at 2x (rules, ticks, typefaces, ...)
  readings-callouts.jsonl  reading of the number callouts in the 86 charts the first reading found them in
  textcolor.csv         textcolor.py: darkness of the type in the title, subtitle and source lines
  ylabel-check.csv      y-label alignment of 48 charts sampled from periods B to D (16 each), read by eye at 3x;
                        it replaces the readings' y_label_align, which took a unit hanging off a one-digit top label
                        for left alignment

Writes charts.csv (one row per chart), inks.csv (colour family counts by period), callouts.csv (one row per chart
with a number callout) and ylabel-check.csv (copied) to OUT_DIR.
"""

import csv
import json
import math
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

here = Path(__file__).parent
manifest_path, out_dir = Path(sys.argv[1]), Path(sys.argv[2])

kept = [l.strip() for l in open(here / "kept_sorted.txt") if l.strip()]
manifest = {r["file"]: r for r in csv.DictReader(open(manifest_path), delimiter="\t")}
fields = {r["file"]: r["field"] for r in csv.DictReader(open(here / "fields.csv"))}
fclass = dict(l.split() for l in open(here / "fieldclass.txt"))
bands = {r["file"]: float(r["band_share"]) for r in csv.DictReader(open(here / "bands.csv"))}
p1 = {json.loads(l)["file"]: json.loads(l) for l in open(here / "readings-pass1.jsonl")}
text = {r["file"]: r for r in csv.DictReader(open(here / "textcolor.csv"))}
p2 = {json.loads(l)["file"]: json.loads(l) for l in open(here / "readings-pass2.jsonl")}

# The measured colours, named by role. Each ink cluster of a chart is assigned to the nearest within dE 6.
INKS = {
    "red": "#c72e29", "salmon": "#d5695d", "pale red": "#ebb3a4",
    "navy": "#016392", "blue": "#0074a5", "steel": "#5d8ca8", "pale steel": "#abbdcb",
    "dark green": "#098154", "green": "#65a479", "pale green": "#afccae",
    "orange": "#fb832d", "light orange": "#fcac67",
    "gold": "#be9c2e", "tan": "#d3ba68", "pale gold": "#e8dbaf",
    "yellow": "#ffe03d", "black": "#010101",
    "bright red": "#ff0c0e", "bright green": "#5ac422",
}


def lab(h):
    r, g, b = (int(h[i:i + 2], 16) / 255 for i in (1, 3, 5))
    f = lambda c: ((c + 0.055) / 1.055) ** 2.4 if c > 0.04045 else c / 12.92
    r, g, b = f(r), f(g), f(b)
    x = (0.4124 * r + 0.3576 * g + 0.1805 * b) / 0.95047
    y = 0.2126 * r + 0.7152 * g + 0.0722 * b
    z = (0.0193 * r + 0.1192 * g + 0.9505 * b) / 1.08883
    t = lambda v: v ** (1 / 3) if v > 0.008856 else 7.787 * v + 16 / 116
    return (116 * t(y) - 16, 500 * (t(x) - t(y)), 200 * (t(y) - t(z)))


INK_LAB = {k: lab(v) for k, v in INKS.items()}
inks = defaultdict(set)
for r in csv.DictReader(open(here / "inks.csv")):
    if int(r["n"]) < 30:
        continue
    p = (float(r["L"]), float(r["a"]), float(r["b"]))
    k, d = min(((k, math.dist(p, v)) for k, v in INK_LAB.items()), key=lambda t: t[1])
    if d < 6:
        inks[r["file"]].add(k)


def period(ymd):
    if ymd < "2011-10":
        return "A"
    if ymd < "2012-07":
        return "B"
    if ymd < "2013-08":
        return "C"
    return "D"


def gray(ink):
    return ink != "" and float(ink) >= 15


def j(v):
    if v is None:
        return ""
    if isinstance(v, list):
        return ";".join(str(x) for x in v if x not in (None, "none"))
    return str(v)


rows = []
for f in kept:
    m = re.search(r"_NS_(\d{4})(\d\d)(\d\d)", f)
    date = f"{m.group(1)}-{m.group(2)}-{m.group(3)}"
    a, b, man = p1[f], p2[f], manifest[f]
    rows.append({
        "file": f,
        "date": date,
        "period": period(date),
        "desk": f.split("-")[0],
        "title": a["title"] or "",
        "subtitle": a.get("subtitle") or "",
        "image": f"https://web.archive.org/web/{man['timestamp']}/{man['original']}",
        "width": man["width"],
        "field": fclass[f],
        "field_hex": fields[f],
        "band_share": bands[f],
        "chart_types": j(a["chart_types"]),
        "n_panels": a["n_panels"],
        "rules": b["rules"],
        "baseline": j(b["baseline"]),
        "x_ticks": b["x_ticks"],
        "minor_ticks": j(b["minor_ticks"]),
        "x_label_position": j(b["x_label_position"]),
        "y_axis_side": b["y_axis_side"],
        "y_label_position": j(b["y_label_position"]),
        "y_unit_top_only": j(a["y_unit_top_only"]),
        "year_labels": j(a["year_labels"]),
        "title_typeface": b["title_typeface"],
        "subtitle_weight": j(b["subtitle_weight"]),
        "text_color": b["text_color"],
        # Glyph cores of black type measure 0 to 10; the dark gray of mid-2013 on, 25 to 70. Gray type is a gray
        # subtitle under a black title: on the pale blue field of 2010-11 the title is gray as well.
        "title_ink": text[f]["title_ink"],
        "subtitle_ink": text[f]["subtitle_ink"],
        "source_ink": text[f]["source_ink"],
        "gray_text": j(gray(text[f]["subtitle_ink"]) and not gray(text[f]["title_ink"])),
        "line_weight": j(b["line_weight"]),
        "bar_gap": j(b["bar_gap"]),
        "labelling": j(a["labelling"]),
        "series_label_style": j(b["series_label_style"]),
        "callouts": j(a["callouts"]),
        "series_colors": j(a["series_colors"]),
        "direction_colors": j(a["direction_colors"]),
        "focal_vs_context": j(a["focal_vs_context"]),
        "credit": j(a["credit"]),
        "has_source": j("Source" in (a.get("source") or "")),
        "has_note": j("Note" in (a.get("source") or "")),
        "unit_line": a.get("unit_line") or "",
        "inks": ";".join(sorted(inks[f])),
        "notes": a.get("notes") or "",
    })

out_dir.mkdir(parents=True, exist_ok=True)
with open(out_dir / "charts.csv", "w", newline="") as fh:
    wr = csv.DictWriter(fh, fieldnames=list(rows[0]))
    wr.writeheader()
    wr.writerows(rows)

counts = defaultdict(Counter)
for r in rows:
    for k in r["inks"].split(";"):
        if k:
            counts[k][r["period"]] += 1
with open(out_dir / "inks.csv", "w", newline="") as fh:
    wr = csv.writer(fh)
    wr.writerow(["ink", "hex", "A", "B", "C", "D", "charts"])
    for k, v in INKS.items():
        c = counts[k]
        wr.writerow([k, "#000000" if k == "black" else v, c["A"], c["B"], c["C"], c["D"], sum(c.values())])
period_of = {r["file"]: r["period"] for r in rows}
keys = ["fill", "text_color", "shape", "tail", "tail_target", "position", "lines", "text", "bold", "marks_latest",
        "point_marker"]
callouts = [json.loads(l) for l in open(here / "readings-callouts.jsonl")]
with open(out_dir / "callouts.csv", "w", newline="") as fh:
    wr = csv.writer(fh)
    wr.writerow(["file", "period", "n_callouts"] + keys)
    for c in callouts:
        if c.get("n_callouts"):
            wr.writerow([c["file"], period_of[c["file"]], c["n_callouts"]] + [j(c.get(k)) for k in keys])
(out_dir / "ylabel-check.csv").write_text((here / "ylabel-check.csv").read_text())
print(len(rows), "charts")
