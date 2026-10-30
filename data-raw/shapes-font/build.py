# /// script
# requires-python = ">=3.10"
# dependencies = ["fonttools"]
# ///
"""Build inst/fonts/ggthemes-shapes.ttf, the font behind `shapes_font()`.

Every glyph the ggthemes shape palettes use that can be drawn from geometry
(circles, partial fills, squares, diamonds, triangles, a star, plus and cross
marks, arrows, gender signs and a check mark) is drawn here at the codepoint
the palettes already use, so `pch_unicode` is unchanged: set the device font
to this family and the same palettes draw.

Size rule. Palettes mix shapes of different kinds, and a font's own glyphs are
drawn to unrelated sizes. Here each glyph is scaled until the convex hull of
its outline has the same area as a circle of radius R0. That is the same
convention R's built-in pch symbols follow (circle, square, diamond and
triangle have equal area), and it is independent of whether a shape is hollow
or filled and of its rotation. Stroke widths are fixed, so scaling a glyph
does not change its weight. Glyphs that would exceed MAX_EXTENT are clamped
(only "!", which is very narrow).

Run:  uv run data-raw/shapes-font/build.py
"""

import math
import sys
from pathlib import Path

from fontTools.fontBuilder import FontBuilder
from fontTools.pens.ttGlyphPen import TTGlyphPen

OUT = Path(__file__).resolve().parents[2] / "inst" / "fonts" / "ggthemes-shapes.ttf"
FAMILY = "ggthemes shapes"
EM = 1000
R0 = 300.0  # radius of the reference circle
TARGET = math.pi * R0**2
MAX_EXTENT = 3.0 * R0  # clamp for glyphs that would otherwise outgrow the em box
W_THIN = 60.0  # stroke width of outlines and thin marks
W_HEAVY = 150.0  # stroke width of the heavy marks


# --- geometry -----------------------------------------------------------------
def area2(pts):
    return sum(x0 * y1 - x1 * y0 for (x0, y0), (x1, y1) in zip(pts, pts[1:] + pts[:1]))


def cw(pts):
    return pts if area2(pts) < 0 else pts[::-1]


def ccw(pts):
    return pts if area2(pts) > 0 else pts[::-1]


def rot(pts, deg):
    c, s = math.cos(math.radians(deg)), math.sin(math.radians(deg))
    return [(x * c - y * s, x * s + y * c) for x, y in pts]


def move(pts, dx, dy):
    return [(x + dx, y + dy) for x, y in pts]


def disk(cx, cy, r, n=120):
    return cw([(cx + r * math.cos(2 * math.pi * i / n), cy + r * math.sin(2 * math.pi * i / n)) for i in range(n)])


def ring(cx, cy, ro, t):
    return [disk(cx, cy, ro), ccw(disk(cx, cy, ro - t))]


def sector(r, a0, a1, n=60):
    arc = [(r * math.cos(math.radians(a0 + (a1 - a0) * i / n)), r * math.sin(math.radians(a0 + (a1 - a0) * i / n))) for i in range(n + 1)]
    return cw([(0.0, 0.0)] + arc)


def hollow(poly, t):
    """Outline of a regular convex polygon: the polygon minus a copy scaled about its centre."""
    cx = sum(p[0] for p in poly) / len(poly)
    cy = sum(p[1] for p in poly) / len(poly)
    inr = min(abs((x1 - x0) * (cy - y0) - (y1 - y0) * (cx - x0)) / math.hypot(x1 - x0, y1 - y0) for (x0, y0), (x1, y1) in zip(poly, poly[1:] + poly[:1]))
    k = (inr - t) / inr
    inner = [(cx + k * (x - cx), cy + k * (y - cy)) for x, y in poly]
    return [cw(poly), ccw(inner)]


def stroke(p0, p1, w):
    (x0, y0), (x1, y1) = p0, p1
    d = math.hypot(x1 - x0, y1 - y0)
    nx, ny = -(y1 - y0) / d * w / 2, (x1 - x0) / d * w / 2
    return cw([(x0 + nx, y0 + ny), (x1 + nx, y1 + ny), (x1 - nx, y1 - ny), (x0 - nx, y0 - ny)])


def polyline(points, w):
    out = [stroke(a, b, w) for a, b in zip(points, points[1:])]
    out += [disk(x, y, w / 2, 24) for x, y in points[1:-1]]
    return out


def regular(n, r, start=90):
    return [(r * math.cos(math.radians(start - 360 * i / n)), r * math.sin(math.radians(start - 360 * i / n))) for i in range(n)]


def hull(points):
    pts = sorted(set(points))
    if len(pts) < 3:
        return pts

    def half(seq):
        h = []
        for p in seq:
            while len(h) >= 2 and (h[-1][0] - h[-2][0]) * (p[1] - h[-2][1]) - (h[-1][1] - h[-2][1]) * (p[0] - h[-2][0]) <= 0:
                h.pop()
            h.append(p)
        return h

    lo, up = half(pts), half(pts[::-1])
    return lo[:-1] + up[:-1]


def hull_area(contours):
    h = hull([p for c in contours for p in c])
    return abs(area2(h)) / 2


def extent(contours):
    xs = [p[0] for c in contours for p in c]
    ys = [p[1] for c in contours for p in c]
    return max(xs) - min(xs), max(ys) - min(ys)


# --- glyph builders: each takes a size a (about the radius) and returns contours -
def g_disk(a): return [disk(0, 0, a)]
def g_ring(a): return ring(0, 0, a, W_THIN)
def g_square_f(a): return [cw([(-a, -a), (-a, a), (a, a), (a, -a)])]
def g_square_o(a): return hollow([(-a, a), (a, a), (a, -a), (-a, -a)], W_THIN)
def g_diamond_f(a): return [cw(rot([(-a, -a), (-a, a), (a, a), (a, -a)], 45))]
def g_diamond_o(a): return hollow(rot([(-a, a), (a, a), (a, -a), (-a, -a)], 45), W_THIN)


def g_tri(a, deg, solid):
    p = rot(regular(3, a), deg)
    return [cw(p)] if solid else hollow(p, W_THIN)


def g_pie(a0, a1):
    return lambda a: ring(0, 0, a, W_THIN) + [sector(a - W_THIN / 2, a0, a1)]


def g_star(a):
    pts = []
    for i in range(10):
        r = a if i % 2 == 0 else a * 0.40
        ang = math.radians(90 - 36 * i)
        pts.append((r * math.cos(ang), r * math.sin(ang)))
    return [cw(pts)]


def g_plus(w):
    return lambda a: [stroke((-a, 0), (a, 0), w), stroke((0, -a), (0, a), w)]


def g_cross(w):
    return lambda a: [stroke((-a, -a), (a, a), w), stroke((-a, a), (a, -a), w)]


def g_asterisk(a):
    return [stroke((-a * math.cos(t), -a * math.sin(t)), (a * math.cos(t), a * math.sin(t)), W_THIN) for t in (0, math.pi / 3, 2 * math.pi / 3)]


def g_circled_plus(a):
    return ring(0, 0, a, W_THIN) + [stroke((-a + W_THIN / 2, 0), (a - W_THIN / 2, 0), W_THIN * 0.8), stroke((0, -a + W_THIN / 2), (0, a - W_THIN / 2), W_THIN * 0.8)]


def g_circled_dot(a): return ring(0, 0, a, W_THIN) + [disk(0, 0, a * 0.30)]
def g_circled_ring(a): return ring(0, 0, a, W_THIN) + ring(0, 0, a * 0.55, W_THIN * 0.8)


def g_bowtie(a):
    h = 0.62 * a
    return [cw([(-a, h), (-a, -h), (0, 0)]), cw([(a, h), (a, -h), (0, 0)])]


def g_hourglass(a):
    w = 0.62 * a
    return [cw([(-w, a), (w, a), (0, 0)]), cw([(-w, -a), (w, -a), (0, 0)])]


def g_star4(a):
    pts = []
    for i in range(8):
        r = a if i % 2 == 0 else a * 0.30
        ang = math.radians(90 - 45 * i)
        pts.append((r * math.cos(ang), r * math.sin(ang)))
    return [cw(pts)]


def g_stile(a):
    return ring(0, 0, a, W_THIN) + [stroke((0, -a + W_THIN / 2), (0, a - W_THIN / 2), W_THIN)]


def g_heavy_ring(a):
    return ring(0, 0, a, 0.46 * a)


def g_w(a):
    return polyline([(-0.95 * a, 0.85 * a), (-0.48 * a, -0.85 * a), (0, 0.30 * a), (0.48 * a, -0.85 * a), (0.95 * a, 0.85 * a)], W_THIN)


def g_u(a):
    r = 0.5 * a
    arc = [(r * math.cos(math.radians(t)), -0.40 * a + r * math.sin(math.radians(t))) for t in range(180, 361, 5)]
    return polyline([(-r, 0.90 * a)] + arc + [(r, 0.90 * a)], W_THIN)


def g_exclaim(a):
    return [stroke((0, -0.05 * a), (0, 1.0 * a), a * 0.46), disk(0, -0.75 * a, a * 0.26)]


def g_less(a): return polyline([(0.55 * a, 0.9 * a), (-0.55 * a, 0), (0.55 * a, -0.9 * a)], W_THIN)


def g_s(a):
    r = 0.5 * a
    top = [(r * math.cos(math.radians(t)), r + r * math.sin(math.radians(t))) for t in range(20, 271, 5)]
    bottom = [(r * math.cos(math.radians(t)), -r + r * math.sin(math.radians(t))) for t in range(90, -161, -5)]
    return polyline(top + bottom[1:], W_THIN)


def g_check(a): return polyline([(-0.75 * a, -0.05 * a), (-0.25 * a, -0.6 * a), (0.8 * a, 0.75 * a)], W_HEAVY)


def g_block_arrow(deg):
    def f(a):
        p = [(0, a), (0.62 * a, 0.12 * a), (0.22 * a, 0.12 * a), (0.22 * a, -a), (-0.22 * a, -a), (-0.22 * a, 0.12 * a), (-0.62 * a, 0.12 * a)]
        return [cw(rot(p, deg))]
    return f


def g_line_arrow(deg):
    def f(a):
        head = 0.62 * a
        segs = [stroke((0, -a), (0, a), W_THIN), stroke((0, a), (head, a - head), W_THIN), stroke((0, a), (-head, a - head), W_THIN)]
        segs.append(disk(0, a, W_THIN / 2, 24))
        return [rot(c, deg) for c in segs]
    return f


def male_arrow(cx, cy, ro, tip, head):
    d = (math.cos(math.radians(45)), math.sin(math.radians(45)))
    start = (cx + ro * d[0], cy + ro * d[1])
    return [stroke(start, tip, W_THIN), stroke(tip, (tip[0] - head, tip[1]), W_THIN), stroke(tip, (tip[0], tip[1] - head), W_THIN), disk(tip[0], tip[1], W_THIN / 2, 24)]


def g_female(a):
    ro = 0.52 * a
    return ring(0, 0.40 * a, ro, W_THIN) + [stroke((0, 0.40 * a - ro), (0, -a), W_THIN), stroke((-0.42 * a, -0.55 * a), (0.42 * a, -0.55 * a), W_THIN)]


def g_male(a):
    ro = 0.52 * a
    return ring(-0.22 * a, -0.22 * a, ro, W_THIN) + male_arrow(-0.22 * a, -0.22 * a, ro, (0.80 * a, 0.80 * a), 0.50 * a)


def g_malefemale(a):
    ro = 0.46 * a
    cy = 0.12 * a
    return ring(0, cy, ro, W_THIN) + male_arrow(0, cy, ro, (0.78 * a, 0.90 * a), 0.46 * a) + [stroke((0, cy - ro), (0, -a), W_THIN), stroke((-0.36 * a, -0.62 * a), (0.36 * a, -0.62 * a), W_THIN)]


def g_trans(a):
    ro = 0.46 * a
    cy = 0.12 * a
    nw = (cy + ro * math.sin(math.radians(135)), ro * math.cos(math.radians(135)))
    tip = (-0.62 * a, cy + 0.82 * a)
    bar = [stroke((tip[0] - 0.22 * a, tip[1] - 0.22 * a), (tip[0] + 0.22 * a, tip[1] + 0.22 * a), W_THIN)]
    return g_malefemale(a) + [stroke((ro * math.cos(math.radians(135)), cy + ro * math.sin(math.radians(135))), tip, W_THIN)] + bar


def g_vmale_stroke(a):
    ro = 0.50 * a
    cy = -0.38 * a
    return ring(0, cy, ro, W_THIN) + [stroke((0, cy + ro), (0, a), W_THIN), stroke((0, a), (0.34 * a, 0.62 * a), W_THIN), stroke((0, a), (-0.34 * a, 0.62 * a), W_THIN), stroke((-0.30 * a, 0.40 * a), (0.30 * a, 0.40 * a), W_THIN), disk(0, a, W_THIN / 2, 24)]


GLYPHS = {
    # ASCII characters that appear in cleveland / kpi palettes
    0x0021: g_exclaim, 0x002B: g_plus(W_THIN), 0x003C: g_less, 0x0053: g_s, 0x0055: g_u, 0x0057: g_w,
    # line arrows
    0x2190: g_line_arrow(90), 0x2191: g_line_arrow(0), 0x2192: g_line_arrow(-90), 0x2193: g_line_arrow(180),
    0x2196: g_line_arrow(45), 0x2197: g_line_arrow(-45), 0x2198: g_line_arrow(-135), 0x2199: g_line_arrow(135),
    # operators
    0x2217: g_asterisk, 0x2295: g_circled_plus, 0x2299: g_circled_dot, 0x229A: g_circled_ring, 0x233D: g_stile, 0x2B58: g_heavy_ring,
    # geometric shapes
    0x25A0: g_square_f, 0x25A1: g_square_o,
    0x25B2: lambda a: g_tri(a, 0, True), 0x25B3: lambda a: g_tri(a, 0, False),
    0x25B6: lambda a: g_tri(a, -90, True), 0x25B7: lambda a: g_tri(a, -90, False),
    0x25BC: lambda a: g_tri(a, 180, True), 0x25BD: lambda a: g_tri(a, 180, False),
    0x25C0: lambda a: g_tri(a, 90, True), 0x25C1: lambda a: g_tri(a, 90, False),
    0x25C6: g_diamond_f, 0x25C7: g_diamond_o, 0x25CB: g_ring, 0x25CF: g_disk,
    0x25D1: g_pie(-90, 90), 0x25D3: g_pie(0, 180), 0x25D4: g_pie(0, 90), 0x25D5: g_pie(90, 360),
    0x2605: g_star, 0x2726: g_star4, 0x29D3: g_bowtie, 0x29D7: g_hourglass,
    0x2B25: g_diamond_f, 0x2B26: g_diamond_o,
    # signs
    0x2640: g_female, 0x2642: g_male, 0x26A5: g_malefemale, 0x26A7: g_trans, 0x26A8: g_vmale_stroke, 0x26AA: g_ring,
    # marks
    0x2714: g_check, 0x2715: g_cross(W_THIN), 0x2716: g_cross(W_HEAVY), 0x2795: g_plus(W_HEAVY), 0xFF0B: g_plus(W_THIN),
    # block arrows
    0x27A1: g_block_arrow(-90), 0x2B05: g_block_arrow(90), 0x2B06: g_block_arrow(0), 0x2B07: g_block_arrow(180),
    0x2B08: g_block_arrow(-45), 0x2B09: g_block_arrow(45), 0x2B0A: g_block_arrow(-135), 0x2B0B: g_block_arrow(135),
}


def solve(builder):
    """Scale `a` until the hull area equals the reference circle (bisection)."""
    lo, hi = 20.0, 1500.0
    for _ in range(60):
        mid = (lo + hi) / 2
        if hull_area(builder(mid)) < TARGET:
            lo = mid
        else:
            hi = mid
    a = (lo + hi) / 2
    w, h = extent(builder(a))
    clamped = False
    if max(w, h) > MAX_EXTENT:
        lo, hi = 20.0, a
        for _ in range(60):
            mid = (lo + hi) / 2
            if max(extent(builder(mid))) < MAX_EXTENT:
                lo = mid
            else:
                hi = mid
        a, clamped = lo, True
    return a, clamped


def build():
    glyph_order = [".notdef"]
    cmap, glyphs, metrics = {}, {}, {}
    pen = TTGlyphPen(None)
    pen.moveTo((100, 0)); pen.lineTo((100, 700)); pen.lineTo((500, 700)); pen.lineTo((500, 0)); pen.closePath()
    glyphs[".notdef"] = pen.glyph()
    metrics[".notdef"] = (600, 100)
    report = []
    for cp, builder in sorted(GLYPHS.items()):
        a, clamped = solve(builder)
        contours = builder(a)
        xs = [p[0] for c in contours for p in c]
        ys = [p[1] for c in contours for p in c]
        dx = EM / 2 - (max(xs) + min(xs)) / 2
        dy = 300 - (max(ys) + min(ys)) / 2
        pen = TTGlyphPen(None)
        for c in contours:
            pts = [(round(x + dx), round(y + dy)) for x, y in c]
            pen.moveTo(pts[0])
            for p in pts[1:]:
                pen.lineTo(p)
            pen.closePath()
        name = f"uni{cp:04X}" if cp <= 0xFFFF else f"u{cp:X}"
        glyph_order.append(name)
        glyphs[name] = pen.glyph()
        metrics[name] = (EM, round(min(xs) + dx))
        cmap[cp] = name
        report.append((cp, hull_area(contours) / TARGET, clamped))
    fb = FontBuilder(EM, isTTF=True)
    fb.setupGlyphOrder(glyph_order)
    fb.setupCharacterMap(cmap)
    fb.setupGlyf(glyphs)
    fb.setupHorizontalMetrics(metrics)
    fb.setupHorizontalHeader(ascent=800, descent=-200)
    fb.setupNameTable({"familyName": FAMILY, "styleName": "Regular", "uniqueFontIdentifier": f"{FAMILY} 1.0", "fullName": FAMILY, "psName": "ggthemes-shapes", "version": "Version 1.0"})
    fb.setupOS2(sTypoAscender=800, sTypoDescender=-200, usWinAscent=800, usWinDescent=200, achVendID="GGTH")
    fb.setupPost()
    OUT.parent.mkdir(parents=True, exist_ok=True)
    fb.save(OUT)
    bad = [r for r in report if abs(r[1] - 1) > 0.02 or r[2]]
    print(f"wrote {OUT} ({OUT.stat().st_size} bytes), {len(cmap)} glyphs")
    for cp, ratio, clamped in bad:
        print(f"  U+{cp:04X}: hull area {ratio:.2f} of reference{' (clamped)' if clamped else ''}", file=sys.stderr)


if __name__ == "__main__":
    build()
