# Changelog

## ggthemes 6.0.0

- [`circlefill_shape_pal()`](http://jrnold.github.io/ggthemes/reference/circlefill_shape_pal.md)
  and
  [`scale_shape_circlefill()`](http://jrnold.github.io/ggthemes/reference/scale_shape_circlefill.md),
  soft-deprecated since ggthemes 5.0.0, now always warn on use
  ([`lifecycle::deprecate_warn()`](https://lifecycle.r-lib.org/reference/deprecate_soft.html))
  instead of only when called directly by the user
- BREAKING CHANGE: Bump minimum supported R version to 4.1.0, and use
  the base pipe (`|>`) instead of the magrittr pipe (`%>%`) in
  `data-raw/` and examples, to match the current Tidyverse Style Guide
  (lintr’s `pipe_consistency_linter` is now a default linter requiring
  `|>`, which was failing CI)
- chore: Modernize GitHub Actions workflows: bump `actions/checkout`,
  `actions/upload-artifact`, and the pkgdown deploy action to their
  current pinned versions; add explicit `permissions:` blocks; migrate
  `test-coverage.yaml` from
  [`covr::codecov()`](http://covr.r-lib.org/reference/codecov.md) to
  [`covr::package_coverage()`](http://covr.r-lib.org/reference/package_coverage.md) +
  the official `codecov/codecov-action`
- Fix stale `branch/master` Codecov badge in README (now points at
  `main`)
- Add `"ao"` (Average Absolute Orientation) and `"was"` (Weighted
  Average Absolute Slope) methods to
  [`bank_slopes()`](http://jrnold.github.io/ggthemes/reference/bank_slopes.md),
  following Heer and Agrawala (2006). Also declare `stats` as an
  explicit `Imports` dependency, since
  [`bank_slopes()`](http://jrnold.github.io/ggthemes/reference/bank_slopes.md)
  calls
  [`stats::median()`](https://rdrr.io/r/stats/median.html)/[`stats::uniroot()`](https://rdrr.io/r/stats/uniroot.html)/
  [`stats::weighted.mean()`](https://rdrr.io/r/stats/weighted.mean.html),
  and fix the
  [`bank_slopes()`](http://jrnold.github.io/ggthemes/reference/bank_slopes.md)
  example so each method’s ratio is actually applied via
  [`coord_fixed()`](https://ggplot2.tidyverse.org/reference/coord_fixed.html)
  instead of just computed and discarded
- Add
  [`bank_plot()`](http://jrnold.github.io/ggthemes/reference/bank_plot.md),
  a wrapper around
  [`bank_slopes()`](http://jrnold.github.io/ggthemes/reference/bank_slopes.md)
  that extracts `x`/`y` directly from an already-built `ggplot`
  (respecting stats, position adjustments, groups, and facets) and
  returns the plot with
  [`coord_fixed()`](https://ggplot2.tidyverse.org/reference/coord_fixed.html)
  applied, so banking a plot no longer requires manually reconstructing
  its plotted vectors
- Bugfix: `bank_slopes(method = "ao")` now returns `NaN` (matching the
  other methods) instead of erroring when there is no vertical variation
  (e.g. a flat line) or too few points to compute a slope
- Bugfix:
  [`bank_plot()`](http://jrnold.github.io/ggthemes/reference/bank_plot.md)
  now rejects a non-positive `layer` with the intended `cli_abort()`
  message instead of falling through to a raw subsetting error
- Bugfix: Fix
  [`excel_new_pal()`](http://jrnold.github.io/ggthemes/reference/excel_new_pal.md)
  example so it actually generates output
  ([\#199](https://github.com/jrnold/ggthemes/issues/199))
- Bugfix:
  [`extended_range_breaks_()`](http://jrnold.github.io/ggthemes/reference/range_breaks.md)
  now respects the `n` argument instead of silently ignoring it
  ([\#139](https://github.com/jrnold/ggthemes/issues/139))
- Add `black` argument to
  [`colorblind_pal()`](http://jrnold.github.io/ggthemes/reference/colorblind.md),
  [`scale_colour_colourblind()`](http://jrnold.github.io/ggthemes/reference/colorblind.md),
  [`scale_color_colorblind()`](http://jrnold.github.io/ggthemes/reference/colorblind.md),
  [`scale_fill_colorblind()`](http://jrnold.github.io/ggthemes/reference/colorblind.md),
  and
  [`scale_fill_colourblind()`](http://jrnold.github.io/ggthemes/reference/colorblind.md);
  set `black = FALSE` to drop black from the colorblind-safe palette
  ([\#178](https://github.com/jrnold/ggthemes/issues/178))
- Add `ink`, `paper`, and `accent` arguments to
  [`theme_foundation()`](http://jrnold.github.io/ggthemes/reference/theme_foundation.md),
  matching ggplot2’s own `theme_gray(ink=, paper=, accent=)`. Branded
  themes
  (e.g. [`theme_economist()`](http://jrnold.github.io/ggthemes/reference/theme_economist.md),
  [`theme_excel()`](http://jrnold.github.io/ggthemes/reference/theme_excel.md))
  intentionally replicate a fixed published style and do not expose
  these ([\#183](https://github.com/jrnold/ggthemes/issues/183))
- Bugfix:
  [`theme_economist()`](http://jrnold.github.io/ggthemes/reference/theme_economist.md)/[`theme_economist_white()`](http://jrnold.github.io/ggthemes/reference/theme_economist.md)
  and
  [`theme_excel()`](http://jrnold.github.io/ggthemes/reference/theme_excel.md)
  now respect the `base_family` and `base_size` arguments
  ([\#135](https://github.com/jrnold/ggthemes/issues/135))
- Bugfix:
  [`theme_excel_new()`](http://jrnold.github.io/ggthemes/reference/theme_excel_new.md)
  now scales `axis.text`, `strip.text`, `legend.text`, and `plot.title`
  with `base_size`, and no longer blanks out axis titles by default
  ([\#176](https://github.com/jrnold/ggthemes/issues/176))
- Bugfix:
  [`geom_rangeframe()`](http://jrnold.github.io/ggthemes/reference/geom_rangeframe.md)
  no longer silently drops the entire range line for an aesthetic when
  the data contains missing values; `na.rm` now behaves as documented
  ([\#177](https://github.com/jrnold/ggthemes/issues/177))
- Clarify in
  [`geom_rangeframe()`](http://jrnold.github.io/ggthemes/reference/geom_rangeframe.md)
  docs (and add an example) that `sides = "trbl"` already draws
  correctly-positioned frames on panels with a secondary axis, since
  [`ggplot2::sec_axis()`](https://ggplot2.tidyverse.org/reference/sec_axis.html)
  only relabels the existing scale rather than introducing a separate
  data range ([\#179](https://github.com/jrnold/ggthemes/issues/179))
- Add `midpoint` argument to
  [`scale_colour_gradient2_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_colour_gradient2_tableau.md),
  [`scale_fill_gradient2_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_colour_gradient2_tableau.md),
  and
  [`scale_color_gradient2_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_colour_gradient2_tableau.md)
  to control which data value maps to the middle color of the diverging
  palette ([\#136](https://github.com/jrnold/ggthemes/issues/136))
- `cleveland_shape_pal(overlap = FALSE)` and
  [`tableau_shape_pal()`](http://jrnold.github.io/ggthemes/reference/tableau_shape_pal.md)
  now warn with an actionable message when their Unicode-derived pch
  codes are likely to fail to render (non-UTF-8 locale), instead of only
  surfacing a cryptic low-level “conversion failure … in ‘mbcsToSbcs’”
  error at draw time
  ([\#164](https://github.com/jrnold/ggthemes/issues/164))
- chore: Replace base
  [`stop()`](https://rdrr.io/r/base/stop.html)/[`warning()`](https://rdrr.io/r/base/warning.html)
  with
  [`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html)/
  [`cli::cli_warn()`](https://cli.r-lib.org/reference/cli_abort.html)
  throughout, matching current tidyverse convention (used by
  ggplot2/dplyr). Error/warning text is largely the same information,
  reformatted for clarity; a few tests were updated to match. Add `cli`
  and `rlang` to Imports.
- chore: Use
  [`rlang::check_installed()`](https://rlang.r-lib.org/reference/is_installed.html)
  instead of a manual
  [`requireNamespace()`](https://rdrr.io/r/base/ns-load.html) +
  [`stop()`](https://rdrr.io/r/base/stop.html) check for the `quantreg`
  dependency in
  [`stat_fivenumber()`](http://jrnold.github.io/ggthemes/reference/stat_fivenumber.md)’s
  weighted case, which prompts an interactive install instead of just
  erroring. The genuinely optional `pander`-availability checks in
  [`theme_pander()`](http://jrnold.github.io/ggthemes/reference/theme_pander.md)/[`palette_pander()`](http://jrnold.github.io/ggthemes/reference/palette_pander.md)
  are left as
  [`requireNamespace()`](https://rdrr.io/r/base/ns-load.html), since
  `check_installed()` is for hard requirements.
- Bugfix: Fix 301 error in link
  ([\#196](https://github.com/jrnold/ggthemes/issues/196))

## ggthemes 5.2.0

CRAN release: 2025-11-30

- Renamed
  [`scale_colour_colorblind()`](http://jrnold.github.io/ggthemes/reference/colorblind.md)
  to
  [`scale_colour_colourblind()`](http://jrnold.github.io/ggthemes/reference/colorblind.md)
  ([\#180](https://github.com/jrnold/ggthemes/issues/180)).
- Updated `theme_solarized` to fix `key.background` color.
- Bugfix: Fix documentation cross-links
  ([\#186](https://github.com/jrnold/ggthemes/issues/186))
- Bugfix: Removed usage of deprecated ggplot functions

## ggthemes 5.1.0

CRAN release: 2024-02-09

- Updated `scale_color_gdocs` and `gdocs_pal` to use current colors.
  Palette extended from 10 to 24 colors.
- Updated tests to be compatible with ggplot 3.5.0
  ([\#153](https://github.com/jrnold/ggthemes/issues/153))
- Removed `legend.title.align` and `legend.text.align` from themes.
  ([\#153](https://github.com/jrnold/ggthemes/issues/153))

## ggthemes 5.0.0

CRAN release: 2023-11-21

- Deprecate `circlefill_shape_pal` and `scale_shape_circlefill`
- Bugfix: Fix failing CRAN tests. Shape scales and palettes could fail
  if glyphs unavailable in graphics devices.
- Bugfix: Add alias to `ggthemes-package`
- Add `quantreg` to suggested packages

## ggthemes 4.2.3

- Fixing URLs for CRAN submission again.

## ggthemes 4.2.2

- Fixing URLs for CRAN submission.

## ggthemes 4.2.1

- Conditionally use the vdiffr package in tests so it complies with
  suggested package policy
  ([\#124](https://github.com/jrnold/ggthemes/issues/124))
- Fix error in `expect_equal` functions
  ([\#123](https://github.com/jrnold/ggthemes/issues/123))
- Fix errors in `geom_tufteboxplot` and `stat_fivenumber` due to missing
  imported objects from ggplot2
  ([\#117](https://github.com/jrnold/ggthemes/issues/117),
  [\#121](https://github.com/jrnold/ggthemes/issues/121))
- Fix text labels in top axis in `theme_economist`
  ([\#115](https://github.com/jrnold/ggthemes/issues/115))
- Update documentation on `geom_rangeframe`; it should be used with
  `coord_cartesian(clip="off")`.
  ([\#120](https://github.com/jrnold/ggthemes/issues/120))

## ggthemes 4.2.0

CRAN release: 2019-05-13

- Add
  [`theme_clean()`](http://jrnold.github.io/ggthemes/reference/theme_clean.md)
  (Thanks [@konradzdeb](https://github.com/konradzdeb),
  [\#105](https://github.com/jrnold/ggthemes/issues/105))
- Add `direction` argument to
  [`scale_color_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_color_tableau.md)
  and
  [`scale_fill_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_color_tableau.md)
  (Thanks [@vadimus202](https://github.com/vadimus202),
  [\#112](https://github.com/jrnold/ggthemes/issues/112))

## ggthemes 4.1.1

CRAN release: 2019-04-09

- Fix bugs in `geom_rangeframe` and `geom_tufteboxplot` caused by
  failing to import `alpha`. (Thanks
  [@flying-sheep](https://github.com/flying-sheep),
  [\#110](https://github.com/jrnold/ggthemes/issues/110))

## ggthemes 4.1.0

CRAN release: 2019-02-19

- Add `type` argument to `scale_color_tableau` so that sequential and
  diverging palettes can be used in discrete scales. (Thanks
  [@onesandzeroes](https://github.com/onesandzeroes),
  [\#108](https://github.com/jrnold/ggthemes/issues/108))
- Fix colors in “Purple” and “Blue-Teal” palettes in
  [`tableau_color_pal()`](http://jrnold.github.io/ggthemes/reference/tableau_color_pal.md).
  (Thanks [@leonawicz](https://github.com/leonawicz),
  [\#109](https://github.com/jrnold/ggthemes/issues/109))

## ggthemes 4.0.1

CRAN release: 2018-08-24

- Fix bugs in
  [`tableau_color_pal()`](http://jrnold.github.io/ggthemes/reference/tableau_color_pal.md).
  Wrong colors in “Tableau 20” theme (Thanks
  [@friskin](https://github.com/friskin),
  [\#95](https://github.com/jrnold/ggthemes/issues/95)), and incorrect
  order of classic color palettes (Thanks
  [@luca-scr](https://github.com/luca-scr),
  [\#96](https://github.com/jrnold/ggthemes/issues/96)).
- Fix fatal bug in
  [`theme_solarized()`](http://jrnold.github.io/ggthemes/reference/theme_solarized.md)
  and
  [`solarized_rebase()`](http://jrnold.github.io/ggthemes/reference/solarized_rebase.md).
  (Thanks [@mdodrill-usgs](https://github.com/mdodrill-usgs),
  [\#97](https://github.com/jrnold/ggthemes/issues/97))

## ggthemes 4.0.0

CRAN release: 2018-07-19

- Added palettes and based on current versions of Excel:
  `excel_pal_new()`,
  [`scale_colour_excel_new()`](http://jrnold.github.io/ggthemes/reference/scale_excel_new.md),
  and
  [`scale_fill_excel_new()`](http://jrnold.github.io/ggthemes/reference/scale_excel_new.md).
  Excel ’97 based scales keep the same names.

- Added
  [`theme_excel_new()`](http://jrnold.github.io/ggthemes/reference/theme_excel_new.md)
  which is based on the chart defaults of current versions of Excel.

- Added Tableau 10 palettes and renamed old palettes in
  [`tableau_color_pal()`](http://jrnold.github.io/ggthemes/reference/tableau_color_pal.md),
  [`scale_color_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_color_tableau.md),
  [`scale_fill_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_color_tableau.md),
  and others. The continuous sequential and diverging palettes are
  improved by including more intermediate steps.

- Updated
  [`theme_gdocs()`](http://jrnold.github.io/ggthemes/reference/theme_gdocs.md)
  to current look.

- Updated
  [`scale_color_gdocs()`](http://jrnold.github.io/ggthemes/reference/scale_gdocs.md)
  and `fill_color_gdocs()` to current color.

- Added `scale_shapes_few()` and
  [`few_shape_pal()`](http://jrnold.github.io/ggthemes/reference/few_shape_pal.md)
  with a shape scale and palette from Stephen Few’s “Show Me the
  Numbers”.

- Removed `stata` argument from `scale_*_economist()` and
  [`theme_economist()`](http://jrnold.github.io/ggthemes/reference/theme_economist.md).

- Changed the format of the `ggthemes_data` object.

- Changed behavior of
  [`few_pal()`](http://jrnold.github.io/ggthemes/reference/few_pal.md).
  If `n = 1`, use gray. If `n > 1` use non-gray colors.

- Changed `tremmel_shape_scale()` to use `alt = TRUE` by default

- Deprecated `tremmel_shape_scale()` argument `n3alt`. Use the `alt`
  argument instead.

- Added a pkgdown site.

- Removed vignette. Move all examples to man pages.

- Bugfix: Fix
  [`theme_few()`](http://jrnold.github.io/ggthemes/reference/theme_few.md)
  ([\#91](https://github.com/jrnold/ggthemes/issues/91))

- Bugfix: Update themes to be consistent with `ggplot>=3.2.0`

## ggthemes 3.5.0

CRAN release: 2018-05-07

- Bugfix: Fix RGB colors in
  [`scale_color_few()`](http://jrnold.github.io/ggthemes/reference/scale_few.md),
  [`scale_fill_few()`](http://jrnold.github.io/ggthemes/reference/scale_few.md),
  and
  [`few_pal()`](http://jrnold.github.io/ggthemes/reference/few_pal.md)
  ([\#89](https://github.com/jrnold/ggthemes/issues/89),
  [@bpbraun](https://github.com/bpbraun))

- Update documentation to include mentions of the maximum number of
  values that discrete scales support
  ([\#85](https://github.com/jrnold/ggthemes/issues/85))

## ggthemes 3.4.2

CRAN release: 2018-04-03

- Bugfix: Fix example code in
  [`theme_economist()`](http://jrnold.github.io/ggthemes/reference/theme_economist.md).
  Thanks [@carlganz](https://github.com/carlganz)
  [\#81](https://github.com/jrnold/ggthemes/issues/81).
- Remove suggests dependencies: `reshape2`, `plyr`, `tidyverse`

## ggthemes 3.4.1

- Bugfix: Resolve duplicate palette names in
  [`canva_palettes()`](http://jrnold.github.io/ggthemes/reference/canva_palettes.md).
  Thanks [@Eluvias](https://github.com/Eluvias)
  ([\#78](https://github.com/jrnold/ggthemes/issues/78))

## ggthemes 3.4.0

CRAN release: 2017-02-19

- Add color palettes from canva.com:
  [`canva_palettes()`](http://jrnold.github.io/ggthemes/reference/canva_palettes.md),
  [`canva_pal()`](http://jrnold.github.io/ggthemes/reference/canva_pal.md),
  [`scale_colour_canva()`](http://jrnold.github.io/ggthemes/reference/scale_colour_canva.md).

- Use `NEWS.md` instead of `NEWS`

- Update Economist examples to put y-axis on the right side.

## ggthemes 3.3.0

CRAN release: 2016-11-24

- Update themes to changes in ggplot 2.1.0.9000. Thanks
  [@juliasilge](https://github.com/juliasilge)
  ([\#71](https://github.com/jrnold/ggthemes/issues/71))

- `tufte_boxplot()` uses `position="dodge"` by default. Thanks
  [@jgellar](https://github.com/jgellar)
  ([\#68](https://github.com/jrnold/ggthemes/issues/68))

- Bugfix: Fix errors in
  [`geom_rangeframe()`](http://jrnold.github.io/ggthemes/reference/geom_rangeframe.md)
  in new version of ggplot2. Thanks
  [@coulmont](https://github.com/coulmont)
  ([\#70](https://github.com/jrnold/ggthemes/issues/70))

## ggthemes 3.2.0

CRAN release: 2016-07-11

- Bugfix: In function
  [`bank_slopes()`](http://jrnold.github.io/ggthemes/reference/bank_slopes.md),
  remove methods `ao`, `gor`, and `lor`. These methods were not
  producing reliable results, and should not produce results much
  different than `ms` or `as`. If used, they will produce a warning, and
  `ms` will be used instead.
  ([\#68](https://github.com/jrnold/ggthemes/issues/68))

## ggthemes 3.1.0

- Add
  [`ptol_pal()`](http://jrnold.github.io/ggthemes/reference/ptol_pal.md),
  [`scale_colour_ptol()`](http://jrnold.github.io/ggthemes/reference/scale_ptol.md),
  and `scale_file_ptol()` based on Paul Tol’s qualitative color
  palettes. Thanks [@jmlondon](https://github.com/jmlondon).
  ([\#65](https://github.com/jrnold/ggthemes/issues/65))

## ggthemes 3.0.4

- Fix panel.grid.major.y colors for
  [`theme_hc()`](http://jrnold.github.io/ggthemes/reference/theme_hc.md).
  Thanks [@flying-sheep](https://github.com/flying-sheep)!
  ([\#64](https://github.com/jrnold/ggthemes/issues/64))

## ggthemes 3.0.3

CRAN release: 2016-04-09

- Bugfix: remove `lintr` tests that broke with new `testthat`.

## ggthemes 3.0.2

CRAN release: 2016-02-26

- Bugfix: export
  [`ggthemes_data()`](http://jrnold.github.io/ggthemes/reference/ggthemes_data.md)

## ggthemes 3.0.1

CRAN release: 2016-01-10

- Bugfix: Remove border around legends in
  [`theme_gdocs()`](http://jrnold.github.io/ggthemes/reference/theme_gdocs.md).
  Thanks SandyMuspratt! Pull request
  [\#53](https://github.com/jrnold/ggthemes/issues/53).

- Bugfix: Remove border around legends in
  [`theme_calc()`](http://jrnold.github.io/ggthemes/reference/theme_calc.md).

- Bugfix: Add colour and fill values to
  [`theme_foundation()`](http://jrnold.github.io/ggthemes/reference/theme_foundation.md).
  This restores its behavior to version 2.2.1. Fixes Issue
  [\#56](https://github.com/jrnold/ggthemes/issues/56).

## ggthemes 3.0.0

CRAN release: 2015-12-20

- For
  [`geom_tufteboxplot()`](http://jrnold.github.io/ggthemes/reference/geom_tufteboxplot.md)
  and `GeomTufteboxplot`, option `median.type` supports only `line` and
  `point` options. Added option `whisker.type` which allows for whiskers
  to be specified by lines or points.

- Changed default stat for
  [`geom_tufteboxplot()`](http://jrnold.github.io/ggthemes/reference/geom_tufteboxplot.md)
  to
  [`stat_fivenumber()`](http://jrnold.github.io/ggthemes/reference/stat_fivenumber.md).

- Added
  [`theme_base()`](http://jrnold.github.io/ggthemes/reference/theme_base.md)
  and
  [`theme_par()`](http://jrnold.github.io/ggthemes/reference/theme_par.md)

- Removed `scale_(x|y)_tufte()`. See issue
  [\#49](https://github.com/jrnold/ggthemes/issues/49)

- [`theme_foundation()`](http://jrnold.github.io/ggthemes/reference/theme_foundation.md)
  rewritten. Removed `use_sizes` argument.

- Import rather than depend on `ggplot2`

- Update geoms, scales, and themes to ggplot \>= 2.0.0

## ggthemes 2.2.1

CRAN release: 2015-07-01

- bugfix: fix R CMD check notes due to change in how it handles non-base
  default packages:
  <https://developer.r-project.org/blosxom.cgi/R-devel/2015/06/29>

- bugfix: fix bad URLs

## ggthemes 2.2.0

- Added
  [`theme_map()`](http://jrnold.github.io/ggthemes/reference/theme_map.md)
  from [@hrbrmstr](https://github.com/hrbrmstr)

## ggthemes 2.1.1

- bugfix: use title case in package title; refer to ggplot2 in title
- bugfix: fix non-escaped URLs in colorblind.R
- bugfix: fix broken URL in few.R
- bugfix: remove non-ascii characters in shapes.R
- bugfix: use
  [`requireNamespace()`](https://rdrr.io/r/base/ns-load.html) instead of
  [`require()`](https://rdrr.io/r/base/library.html)

## ggthemes 2.1.0

CRAN release: 2014-12-18

- New theme and scale based on Highcharts JS: `scale_*_hc()`,
  [`theme_hc()`](http://jrnold.github.io/ggthemes/reference/theme_hc.md).
  Thanks jbkunst!

## ggthemes 2.0.0

- New options for
  [`geom_tufteboxplot()`](http://jrnold.github.io/ggthemes/reference/geom_tufteboxplot.md).
  `median.type` takes values “point”, “box”, or “line”. Option `usebox`
  is no longer supported, and equivalent to `median.type="box"`. Thanks
  weitzner! Issue [\#13](https://github.com/jrnold/ggthemes/issues/13),
  PR [\#19](https://github.com/jrnold/ggthemes/issues/19).

- All theme functions have `base_size` and `base_family` as first two
  arguments. This affects
  [`theme_economist_white()`](http://jrnold.github.io/ggthemes/reference/theme_economist.md),
  [`theme_excel()`](http://jrnold.github.io/ggthemes/reference/theme_excel.md),
  [`theme_pander()`](http://jrnold.github.io/ggthemes/reference/theme_pander.md),
  [`theme_solid()`](http://jrnold.github.io/ggthemes/reference/theme_solid.md),
  and
  [`theme_tufte()`](http://jrnold.github.io/ggthemes/reference/theme_tufte.md).
  Thanks ptoche! Issue
  [\#25](https://github.com/jrnold/ggthemes/issues/25).

- [`theme_pander()`](http://jrnold.github.io/ggthemes/reference/theme_pander.md):
  Options `ff` and `fs` are deprecated; use `base_family` and
  `base_size` options instead, respectively.

## ggthemes 1.9.0

- added vignette

- added themes / scales based on factory defaults of pander package:
  `pander_palette()`,
  [`scale_color_pander()`](http://jrnold.github.io/ggthemes/reference/scale_pander.md),
  [`scale_fill_pander()`](http://jrnold.github.io/ggthemes/reference/scale_pander.md),
  [`theme_pander()`](http://jrnold.github.io/ggthemes/reference/theme_pander.md).
  Thanks daroczig.

- added additional fill and gradient color scales:
  [`scale_fill_fivethirtyeight()`](http://jrnold.github.io/ggthemes/reference/scale_fivethirtyeight.md),
  [`scale_colour_gradient_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_colour_gradient_tableau.md),
  [`scale_fill_gradient_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_colour_gradient_tableau.md),
  [`scale_fill_continuous_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_colour_gradient_tableau.md),
  [`scale_colour_gradient2_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_colour_gradient2_tableau.md),
  [`scale_fill_gradient2_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_colour_gradient2_tableau.md).
  Thanks bowerth.

## ggthemes 1.8.0

- added themes and color scale from fivethirtyeight.com:
  [`theme_fivethirtyeight()`](http://jrnold.github.io/ggthemes/reference/theme_fivethirtyeight.md),
  [`fivethirtyeight_pal()`](http://jrnold.github.io/ggthemes/reference/fivethirtyeight_pal.md),
  [`scale_color_fivethirtyeight()`](http://jrnold.github.io/ggthemes/reference/scale_fivethirtyeight.md)

## ggthemes 1.7.0

CRAN release: 2014-04-22

- added a new breaks algorithm: `scales_extended_range_breaks()`,
  [`extended_range_breaks()`](http://jrnold.github.io/ggthemes/reference/range_breaks.md)
- added scales which implement the breaks algorithm: `scale_x_tufte()`,
  `scale_y_tufte()`
- added new label format:
  [`smart_digits()`](http://jrnold.github.io/ggthemes/reference/smart_digits.md),
  [`smart_digits_format()`](http://jrnold.github.io/ggthemes/reference/smart_digits.md)

## ggthemes 1.6.1

- fix bug in
  [`theme_wsj()`](http://jrnold.github.io/ggthemes/reference/theme_wsj.md)
  (issue [\#17](https://github.com/jrnold/ggthemes/issues/17))

## ggthemes 1.6.0

CRAN release: 2013-12-14

- added
  [`theme_solid()`](http://jrnold.github.io/ggthemes/reference/theme_solid.md)

## ggthemes 1.5.1

CRAN release: 2013-10-20

- fix failures in R CMD check

## ggthemes 1.5.0

- added alternative Solarized theme:
  [`theme_solarized_2()`](http://jrnold.github.io/ggthemes/reference/theme_solarized.md)
- [`theme_solarized()`](http://jrnold.github.io/ggthemes/reference/theme_solarized.md):
  adjusted the colors
- added LibreOffic Calc themes and palettes:
  [`theme_calc()`](http://jrnold.github.io/ggthemes/reference/theme_calc.md),
  [`calc_pal()`](http://jrnold.github.io/ggthemes/reference/calc_pal.md),
  [`scale_fill_calc()`](http://jrnold.github.io/ggthemes/reference/scale_calc.md),
  [`scale_colour_calc()`](http://jrnold.github.io/ggthemes/reference/scale_calc.md),
  `cacl_shape_pal()`,
  [`scale_shape_calc()`](http://jrnold.github.io/ggthemes/reference/scale_shape_calc.md)
- added Google Docs themes and palettes:
  [`theme_gdocs()`](http://jrnold.github.io/ggthemes/reference/theme_gdocs.md),
  [`gdocs_pal()`](http://jrnold.github.io/ggthemes/reference/gdocs_pal.md),
  [`scale_fill_gdocs()`](http://jrnold.github.io/ggthemes/reference/scale_gdocs.md),
  [`scale_colour_gdocs()`](http://jrnold.github.io/ggthemes/reference/scale_gdocs.md)
- fixed some examples

## ggthemes 1.4.0

- fix bug in default palettes of
  [`scale_colour_excel()`](http://jrnold.github.io/ggthemes/reference/scale_excel.md)
  and
  [`scale_fill_excel()`](http://jrnold.github.io/ggthemes/reference/scale_excel.md).

## ggthemes 1.3.4

- added Tableau sequential colour palettes:
  [`tableau_seq_gradient_pal()`](http://jrnold.github.io/ggthemes/reference/tableau_gradient_pal.md),
  [`scale_colour_gradient_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_colour_gradient_tableau.md),
  [`scale_fill_gradient_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_colour_gradient_tableau.md).
- added Tableau diverging colour palettes:
  [`tableau_div_gradient_pal()`](http://jrnold.github.io/ggthemes/reference/tableau_gradient_pal.md),
  [`scale_colour_gradient2_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_colour_gradient2_tableau.md),
  [`scale_fill_gradient2_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_colour_gradient2_tableau.md).
- `tableau_colour_pal()`: added palette “cyclical

## ggthemes 1.3.3

CRAN release: 2013-03-25

- fix issue [\#11](https://github.com/jrnold/ggthemes/issues/11): error
  with fonts and
  [`theme_wsj()`](http://jrnold.github.io/ggthemes/reference/theme_wsj.md)
  in Windows

## ggthemes 1.3.1

CRAN release: 2012-12-22

- [`bank_slopes()`](http://jrnold.github.io/ggthemes/reference/bank_slopes.md)
  returns y/x aspect ratio to be compatible with
  [`coord_fixed()`](https://ggplot2.tidyverse.org/reference/coord_fixed.html)
- improved documentation

## ggthemes 1.3.0

- renamed `theme_excel2003()` to
  [`theme_excel()`](http://jrnold.github.io/ggthemes/reference/theme_excel.md)
- replace `scale_fill_excel2003()` and `scale_fill_excel10()` with
  [`scale_fill_excel()`](http://jrnold.github.io/ggthemes/reference/scale_excel.md)
- replaced `scale_colour_excel2003()` and `scale_colour_excel10()` with
  [`scale_colour_excel()`](http://jrnold.github.io/ggthemes/reference/scale_excel.md)
- replaced `excel2003_pal()` and `excel10_pal()` with
  [`excel_pal()`](http://jrnold.github.io/ggthemes/reference/excel_pal.md)
- renamed
  [`theme_base()`](http://jrnold.github.io/ggthemes/reference/theme_base.md)
  to
  [`theme_foundation()`](http://jrnold.github.io/ggthemes/reference/theme_foundation.md)

## ggthemes 1.2.0

- added colorblind scales:
  [`colorblind_pal()`](http://jrnold.github.io/ggthemes/reference/colorblind.md),
  `scale_*_colorblind()`.

## ggthemes 1.1.0

- added Wall Street Journal themes, palettes, scales:
  [`theme_wsj()`](http://jrnold.github.io/ggthemes/reference/theme_wsj.md),
  [`wsj_pal()`](http://jrnold.github.io/ggthemes/reference/wsj_pal.md),
  [`scale_colour_wsj()`](http://jrnold.github.io/ggthemes/reference/scale_wsj.md),
  and
  [`scale_fill_wsj()`](http://jrnold.github.io/ggthemes/reference/scale_wsj.md).
- added function
  [`bank_slopes()`](http://jrnold.github.io/ggthemes/reference/bank_slopes.md)
  : methods for determining the optimal slope ratio.
- added `theme-foundation()`: a theme designed to be easy to extend into
  new themes.
- added NEWS file
