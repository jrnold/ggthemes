# Stata reference graphs

Reference images used to match `theme_stata()` against Stata's current
output. Downloaded from <https://www.stata.com/features/overview/new-graph-style/>
(StataCorp, Stata 18.0-generated SVG).

| file | scheme | graph type |
|------|--------|------------|
| stcolor1 | stcolor | twoway scatter + lowess, legend right |
| stcolor2 | stcolor | by-graph (2x2 facets) scatter |
| stcolor3 | stcolor | horizontal stacked bar |
| stcolor4 | stcolor | margins plot, connected + CI bars |
| s2color1 | s2color | same graph as stcolor1 in the pre-18 scheme |

`s2color1` is served as `scheme5_stcolor.svg` but is plainly the s2color
"before" image; renamed here to match its contents.

These are StataCorp's images. They are kept out of version control (see
`data-raw/reference/.gitignore`) and are for local comparison only -- they
must not be redistributed in the package.

Re-download with `data-raw/reference/stata/fetch.sh`.
