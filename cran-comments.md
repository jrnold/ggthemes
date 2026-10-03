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

- Local: macOS Tahoe 26.6.2 (aarch64), R 4.6.1, `R CMD check --as-cran`.
- GitHub Actions: macOS and Windows (R release), Ubuntu (R-devel, release,
  oldrel-1).
- win-builder: R-devel.

## Reverse dependencies

We checked 143 reverse dependencies (125 from CRAN + 18 from Bioconductor),
comparing R CMD check results across CRAN and dev versions of this package.

* We saw 0 new problems.
* We failed to check 11 CRAN packages, for reasons unrelated to this package:
  eight failed to compile on the check machine (Eagle, epicR, harmony,
  normalblockr, pdSpecEst, PRECAST, symphony, ZVCV), two need Tcl/Tk with X11
  (patterncausality, RcmdrPlugin.KMggplot2), and esquisse timed out with both
  versions.
