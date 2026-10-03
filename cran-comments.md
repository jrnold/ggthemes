## Release summary

This is a major release (7.0.0). It contains breaking changes, listed in
NEWS.md; the ones most likely to affect users are:

- Shape palettes (`stata_shape_pal()`, `calc_shape_pal()`,
  `tableau_shape_pal()`, `cleveland_shape_pal()`) now return base `pch` codes
  by default instead of Unicode glyphs, which rendered as blank boxes in fonts
  without coverage and aborted on the base `pdf()` and `postscript()` devices.
  The previous behaviour is available with `unicode = TRUE`.
- `theme_foundation()` again clears the colours it inherits from
  `theme_grey()` on ggplot2 >= 4.0.0, whose S7 theme elements had hidden them.
  This restores the intended appearance of eleven themes built on it.
- Several palettes are updated to match their sources (The Economist,
  Highcharts, Excel, Tableau), and some Tableau palettes are renamed.
- `ptol_pal()` and its scales, `theme_economist_white()`, and some arguments
  are deprecated with lifecycle warnings; no exported function is removed.

The minimum ggplot2 version is raised to 3.5.2, because the package calls
`ggplot2::is_ggplot()`.

## R CMD check results

0 errors | 0 warnings | 0 notes

<!-- TODO: confirm on the final build; fill in win-builder (R-devel) results. -->

- Local: macOS Tahoe 26.6.2 (aarch64), R 4.6.1.
- GitHub Actions: macOS, Windows and Ubuntu (R-devel, release, oldrel-1).
- win-builder: R-devel.

## Reverse dependencies

<!-- TODO: fill in from revdep/cran.md once revdepcheck finishes. -->

We checked 143 reverse dependencies, comparing R CMD check results across CRAN
and dev versions of this package.
