# ggthemes shapes

`ggthemes-shapes.ttf` is the font behind `register_shapes_font()`. It holds 63 glyphs
(circles and partial fills, squares, diamonds, triangles, a star, plus and cross
marks, arrows, gender signs and a check mark) at the Unicode characters the
ggthemes shape palettes use, each scaled to the same convex-hull area.

It is original work, drawn by `data-raw/shapes-font/build.py` from geometry
alone (no third-party outlines), and is distributed under the same license as
the ggthemes package. Rebuild it with `uv run data-raw/shapes-font/build.py`.
