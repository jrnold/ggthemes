# Economist chart style reference

`theme_economist()` and `economist_pal()` are matched against *The
Economist visual styleguide*, version 1.2, dated 4 May 2017 and issued
by the paper's own graphics desk. That document is the one that
introduced the chart redesign The Economist still publishes today, so
it -- not the pre-2017 look ggthemes used to ship -- is the reference.

| page | what it fixes |
|------|---------------|
| 3  | what changed in the redesign: white background, new palette, rotated tag, new typeface |
| 5  | typefaces: Econ Sans and Econ Sans Cnd, and which weight is used where |
| 6  | standard print chart: dimensions, type sizes, tick-mark lengths and weights |
| 7  | standard web chart: built at print widths, exported at 179.22% |
| 11 | print chart palette (CMYK) |
| 12 | web chart palette (hex) -- the source for `main` and `scales` |
| 25 | miscellaneous styling: highlight panels, index charts, broken scales, source-note weight |

## Colour values

`data-raw/theme-data/economist.yml` quotes p.12 verbatim, because that
page is the only one giving hex values. The print palette on p.11 is
specified in CMYK, and naive CMYK->RGB conversion does not reproduce
the colours as rendered -- C10/K25 gridlines convert to a green-tinted
grey that is plainly not what the printed charts show. Where the theme
needs a colour that only p.11 specifies, it uses the nearest hex that
p.12 does document, and says so in a comment:

* panel surround and strip background: `#e9edf0`, the "boxes/nav" tint
* gridlines: `#b7c6cf`

## Geometry

Tick marks are the clearest break from the pre-2017 theme. The
styleguide (p.6) draws them *below* the x-axis baseline at 2-5pt, where
ggthemes previously drew them inside the panel via a negative
`axis.ticks.length`. The y axis carries no rule and no ticks; its
labels sit to the right of the panel.

## Reference images

None are checked in. The styleguide PDF is The Economist's own
material and must not be redistributed in the package; see
`data-raw/reference/.gitignore`. Re-download a local copy with
`data-raw/reference/economist/fetch.sh`.
