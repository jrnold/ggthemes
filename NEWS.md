# ggthemes (development version)

- BREAKING CHANGE: `stata_shape_pal()`, `calc_shape_pal()`,
  `tableau_shape_pal()` and `cleveland_shape_pal()` now return base pch codes
  by default instead of pch codes derived from Unicode glyphs. R draws a
  negative pch by asking the device font for that codepoint, so these palettes
  rendered as blank boxes in a font without coverage — R's default `sans`
  covers one of the eight codepoints they relied on — and aborted outright on
  base `pdf()`/`postscript()`. Pass `unicode = TRUE` to restore the previous
  values. `scale_shape_stata()`, `scale_shape_calc()`, `scale_shape_tableau()`
  and `scale_shape_cleveland()` gain the same argument.
- BREAKING CHANGE: `max_n` is reduced on the default branch for the palettes
  whose source symbols have no font-independent equivalent: `calc` 13 to 7,
  `tableau_shape_pal("filled")` 10 to 6, `tableau_shape_pal("default")` 10 to
  8, `cleveland_shape_pal(overlap = FALSE)` 5 to 3 and
  `tableau_shape_pal("proportions")` 5 to 2. Those shapes are dropped rather
  than approximated by a different shape. `stata_shape_pal()` and
  `few_shape_pal()` are unaffected — their symbol sets map exactly.
- BREAKING CHANGE: the `pch` column of the shape tables in `ggthemes_data` now
  holds the font-independent base pch, `NA` where there is none. The previous
  Unicode-derived values move to a new `pch_unicode` column, and a new `shape`
  column carries the canonical shape name both are derived from.
- BREAKING CHANGE: `tremmel_shape_pal()` returned symbol sets that did not
  match Tremmel (1995). `n = 2` now returns a solid circle and a plus sign (was
  two circles), `overlap = TRUE` returns an empty circle and a plus sign (was a
  square and a plus sign), and `alt = TRUE` returns a solid circle, plus sign
  and empty triangle (was identical to `alt = FALSE`, making the argument a
  no-op).
- Fix `scale_shape_tremmel()` defaulting to `alt = TRUE` while
  `tremmel_shape_pal()` defaulted to `alt = FALSE`, so a palette and its own
  scale disagreed at `n = 3`. Both now default to `FALSE`, the variant
  Tremmel's Experiment 1 measured.
- Fix `cleveland_shape_pal(overlap = TRUE)` drawing a `W` where an `S` was
  intended; the stored row paired the name `LATIN CAPITAL LETTER S` with
  pch 87.
- Fix mislabelled and corrupted shape data: LibreOffice's `BLACK
  DOWN-POINTING CHARACTER` (now `TRIANGLE`), Google Docs' star named
  `MULTIPLICATION X`, Excel's em dash declared as `U+2013`, and Tableau's
  `CLOUD WITH RAIN`, stored as a mojibake sequence rather than `U+1F327`.
- The shape tables are now validated as they are built: a shape name outside
  the vocabulary, a `character` that disagrees with its own `unicode`, or two
  shapes in one palette sharing a pch all fail the build, and the same checks
  run as tests against the built data.
- `warn_unicode_pch()`'s locale guess is joined by a real font-coverage check
  using `systemfonts::glyph_info()` when `systemfonts` is installed, naming the
  glyphs the device font cannot draw. `systemfonts` is used in `Suggests`. The
  locale and coverage checks are independent failure modes and both run: a
  UTF-8 session can still meet a font with no glyph, and a font with full
  coverage still fails with `mbcsToSbcs` on a non-UTF-8 session. Note that R
  exposes no way to read back a device's `family=`, so the probe measures the
  default font and the warning names the font it actually measured.
- BREAKING CHANGE: The Tableau palette `"Red-Blue-Brown"` has been renamed to
  `"Blue-Red-Brown"`, matching both the name Tableau uses and the palette's
  actual colour order (blue, red, brown). The old name still works but warns.
- BREAKING CHANGE: The Tableau palette `"Classic Area-Brown"` has been renamed
  to `"Classic Area Brown"`, for consistency with its siblings
  `"Classic Area Red"` and `"Classic Area Green"`. The old name still works but
  warns.
- Fix two corrupted colours in the `"Gray Warm"` ordered-sequential Tableau
  palette. Position 7 was `#b047a4` (a magenta, in a warm-grey ramp) and is now
  `#b0a8a4`; position 18 was `#665c51`, which broke the ramp's monotonic blue
  channel, and is now `#665c5a`. Plots using
  `scale_colour_gradient_tableau("Gray Warm")` will change appearance.
- Fix a duplicated colour (`#fa9d4f`) in the `"Red-Gold"` ordered-sequential
  Tableau palette, which gave it 21 colours where every other 20-step Tableau
  sequential palette has 20. Plots using `"Red-Gold"` will change appearance.
- Remove `data-raw/theme-data/tableau-new.yml`, an unused duplicate of
  `tableau.yml`.
- The test suite no longer requires suggested packages to be installed.
  `expect_hexcolor()` used **stringr** and **glue** on every palette test,
  and stringr had moved from `Imports` to `Suggests`; it now uses base
  equivalents. The tests that genuinely need **withr** or **farver** skip
  when those are absent instead of erroring.
- `geom_rangeframe()` now errors on a `sides` value that names no side, rather
  than silently drawing nothing. `sides` packs side letters into one string, so
  a typo such as `sides = "xy"` previously produced an empty layer with no
  message. Valid values are strings made up of `"t"`, `"r"`, `"b"` and `"l"`.
- Fix the `?extended_range_breaks` help page, which described a function
  `scales_extended_range_breaks()` that does not exist and attributed the
  wrong return value to each function. `extended_range_breaks_()` returns the
  break values; `extended_range_breaks()` returns a breaks function. The page
  now also warns that ggplot2 passes a `breaks` function the expanded scale
  limits, so `breaks = extended_range_breaks()` labels the panel edges rather
  than the data extremes; apply the function to the data to label the extremes.
- Fix `theme_economist_white()` failing on installations without **dplyr**.
  The internal `get_colors()` helper called `dplyr::filter()`, but dplyr is a
  suggested package, not an import; it now uses base subsetting. The test
  suite no longer uses dplyr either, so `R CMD check` passes with only the
  hard dependencies installed.
- Fix the `@family` tags that split related help pages apart. Word-order and
  singular/plural inconsistencies (`stata colour`, `solarized colour`,
  `shape stata`, `shape tableau`) each put one page in a family of its own, so
  it linked to nothing. `?extended_range_breaks` had no family at all and was
  unreachable from `theme_tufte()`, `geom_rangeframe()` and
  `geom_tufteboxplot()`, which it is meant to be used with; those four now
  cross-reference each other.
- Add vdiffr visual regression baselines for every exported theme, and swatch
  baselines plus property assertions (valid hex, no duplicate colours, stable
  lengths, monotone lightness, no out-of-family colour, monotone grey ramps)
  for the Tableau palette families. These are development-only tests and do not
  run on CRAN; `vdiffr (>= 1.0.6)` and `farver` are now used in `Suggests`
  (#219).

- Add support for Stata's `st` scheme family, which has been Stata's factory
  default since Stata 18. `stata_pal()` and `scale_colour_stata()` gain the
  `"stcolor"` scheme (the `stc1`--`stc15` colours), and `theme_stata()` gains
  the `"stcolor"`, `"stcolor_alt"`, `"stmono1"`, `"stmono2"` and `"stsj"`
  schemes. `stgcolor` and `stgcolor_alt` are not included: they differ from
  `stcolor` only in physical graph dimensions, which a ggplot2 theme does not
  carry.
- The 19 named colours Stata 18 added (`stc1`--`stc15` plus the `stblue`,
  `stred`, `stgreen` and `styellow` aliases) are now in
  `ggthemes_data$stata$colors$names`.
- Omitting `scheme` in `stata_pal()`, `scale_colour_stata()`,
  `scale_fill_stata()` and `theme_stata()` is now soft-deprecated. It still
  resolves to `"s2color"`, but the default will change to `"stcolor"` in
  ggthemes 7.0.0, following Stata. Pass `scheme` explicitly to keep the
  current appearance.
- BEHAVIOUR CHANGE: `stata_pal("mono")` returned the wrong colours at
  positions 6 and 12 (`gs14` and `gs15` instead of `gs12` and `gs5`). It now
  matches Stata's `s1mono`/`s2mono` exactly, including the fact that Stata
  repeats `gs12` and `gs5` at positions 14 and 15. Plots using `"mono"` with
  six or more levels will change.
- Fix `stata_pal("economist")`, which returned `NA` as its first colour
  because the scheme referred to a non-existent colour `dkblue`. It is now
  `edkblue`, matching Stata's `scheme-economist.scheme`.
- Fix `attr(stata_pal(scheme), "max_n")`, which reported `2` rather than `15`
  because it measured the columns of the palette table instead of its rows.
- Add Apple Numbers support: `numbers_pal()`, `scale_colour_numbers()`,
  `scale_color_numbers()`, `scale_fill_numbers()`, and `theme_numbers()`.
  All 12 Numbers chart palettes are available by their Numbers names
  (`"Classic"`, the default, through `"Spectrum"`), each providing six
  series colors. `theme_numbers()` follows the chart style defaults that
  ship inside Numbers: no panel fill, gridlines in the value direction
  only, a bottom chart border, and no tick marks.
- The palettes are generated from Apple Numbers 14.5 by
  `data-raw/reference/numbers/fetch.sh` and `data-raw/numbers_palettes.R`;
  see `data-raw/reference/numbers/SOURCES.md`. This replaces
  `data-raw/theme-data/numbers-charts.yml`, an unused file added in 2018
  that was never wired into `data-raw/build.R` and held iWork-era colors
  matching no current Numbers palette.

- Fix two incorrect colours in the Google Docs palette, checked against the
  series colours a current Google Sheets chart actually renders. `teal 2` was
  `#ff994d`, a duplicate of `orange 2`, and is now `#7ed1d7`; `teal 3` was
  `#c9e4e7` and is now `#b5e5e8`. This changes the output of `gdocs_pal()`,
  `scale_colour_gdocs()`, and `scale_fill_gdocs()` for more than 11 colours.
  The other 22 colours were already correct.
- `theme_gdocs()` now matches the text colours Google Sheets uses. Sheets
  applies a graded hierarchy rather than one grey: axis tick labels are black,
  legend labels `#1a1a1a`, and axis titles and the x-axis line `#333333`. The
  chart title (`#757575`) and gridlines (`#cccccc`) are unchanged.

# ggthemes 6.0.0

- `circlefill_shape_pal()` and `scale_shape_circlefill()`, soft-deprecated
  since ggthemes 5.0.0, now always warn on use (`lifecycle::deprecate_warn()`)
  instead of only when called directly by the user
- BREAKING CHANGE: Bump minimum supported R version to 4.1.0, and use the
  base pipe (`|>`) instead of the magrittr pipe (`%>%`) in `data-raw/` and
  examples, to match the current Tidyverse Style Guide (lintr's
  `pipe_consistency_linter` is now a default linter requiring `|>`, which was
  failing CI)
- chore: Modernize GitHub Actions workflows: bump `actions/checkout`,
  `actions/upload-artifact`, and the pkgdown deploy action to their current
  pinned versions; add explicit `permissions:` blocks; migrate
  `test-coverage.yaml` from `covr::codecov()` to `covr::package_coverage()` +
  the official `codecov/codecov-action`
- Fix stale `branch/master` Codecov badge in README (now points at `main`)
- Add `"ao"` (Average Absolute Orientation) and `"was"` (Weighted Average
  Absolute Slope) methods to `bank_slopes()`, following Heer and Agrawala
  (2006). Also declare `stats` as an explicit `Imports` dependency, since
  `bank_slopes()` calls `stats::median()`/`stats::uniroot()`/
  `stats::weighted.mean()`, and fix the `bank_slopes()` example so each
  method's ratio is actually applied via `coord_fixed()` instead of just
  computed and discarded
- Add `bank_plot()`, a wrapper around `bank_slopes()` that extracts `x`/`y`
  directly from an already-built `ggplot` (respecting stats, position
  adjustments, groups, and facets) and returns the plot with
  `coord_fixed()` applied, so banking a plot no longer requires manually
  reconstructing its plotted vectors
- Bugfix: `bank_slopes(method = "ao")` now returns `NaN` (matching the other
  methods) instead of erroring when there is no vertical variation (e.g. a
  flat line) or too few points to compute a slope
- Bugfix: `bank_plot()` now rejects a non-positive `layer` with the intended
  `cli_abort()` message instead of falling through to a raw subsetting error
- Bugfix: Fix `excel_new_pal()` example so it actually generates output (#199)
- Bugfix: `extended_range_breaks_()` now respects the `n` argument instead of
  silently ignoring it (#139)
- Add `black` argument to `colorblind_pal()`, `scale_colour_colourblind()`,
  `scale_color_colorblind()`, `scale_fill_colorblind()`, and
  `scale_fill_colourblind()`; set `black = FALSE` to drop black from the
  colorblind-safe palette (#178)
- Add `ink`, `paper`, and `accent` arguments to `theme_foundation()`,
  matching ggplot2's own `theme_gray(ink=, paper=, accent=)`. Branded themes
  (e.g. `theme_economist()`, `theme_excel()`) intentionally replicate a fixed
  published style and do not expose these (#183)
- Bugfix: `theme_economist()`/`theme_economist_white()` and `theme_excel()` now
  respect the `base_family` and `base_size` arguments (#135)
- Bugfix: `theme_excel_new()` now scales `axis.text`, `strip.text`,
  `legend.text`, and `plot.title` with `base_size`, and no longer blanks out
  axis titles by default (#176)
- Bugfix: `geom_rangeframe()` no longer silently drops the entire range line
  for an aesthetic when the data contains missing values; `na.rm` now behaves
  as documented (#177)
- Clarify in `geom_rangeframe()` docs (and add an example) that
  `sides = "trbl"` already draws correctly-positioned frames on panels with
  a secondary axis, since `ggplot2::sec_axis()` only relabels the existing
  scale rather than introducing a separate data range (#179)
- Add `midpoint` argument to `scale_colour_gradient2_tableau()`,
  `scale_fill_gradient2_tableau()`, and `scale_color_gradient2_tableau()` to
  control which data value maps to the middle color of the diverging
  palette (#136)
- `cleveland_shape_pal(overlap = FALSE)` and `tableau_shape_pal()` now warn
  with an actionable message when their Unicode-derived pch codes are
  likely to fail to render (non-UTF-8 locale), instead of only surfacing a
  cryptic low-level "conversion failure ... in 'mbcsToSbcs'" error at draw
  time (#164)
- chore: Replace base `stop()`/`warning()` with `cli::cli_abort()`/
  `cli::cli_warn()` throughout, matching current tidyverse convention (used
  by ggplot2/dplyr). Error/warning text is largely the same information,
  reformatted for clarity; a few tests were updated to match. Add `cli` and
  `rlang` to Imports.
- chore: Use `rlang::check_installed()` instead of a manual
  `requireNamespace()` + `stop()` check for the `quantreg` dependency in
  `stat_fivenumber()`'s weighted case, which prompts an interactive install
  instead of just erroring. The genuinely optional `pander`-availability
  checks in `theme_pander()`/`palette_pander()` are left as
  `requireNamespace()`, since `check_installed()` is for hard requirements.
- Bugfix: Fix 301 error in link (#196)

# ggthemes 5.2.0

- Renamed `scale_colour_colorblind()` to `scale_colour_colourblind()` (#180).
- Updated `theme_solarized` to fix `key.background` color.
- Bugfix: Fix documentation cross-links (#186)
- Bugfix: Removed usage of deprecated ggplot functions

# ggthemes 5.1.0

- Updated `scale_color_gdocs` and `gdocs_pal` to use current colors. Palette extended from 10 to 24 colors.
- Updated tests to be compatible with ggplot 3.5.0 (#153)
- Removed `legend.title.align` and `legend.text.align` from themes. (#153)

# ggthemes 5.0.0

- Deprecate `circlefill_shape_pal` and `scale_shape_circlefill`
- Bugfix: Fix failing CRAN tests. Shape scales and palettes could fail if glyphs  unavailable in graphics devices.
- Bugfix: Add alias to `ggthemes-package`
- Add `quantreg` to suggested packages

# ggthemes 4.2.3

- Fixing URLs for CRAN submission again.

# ggthemes 4.2.2

- Fixing URLs for CRAN submission.

# ggthemes 4.2.1

- Conditionally use the vdiffr package in tests so it complies with suggested package policy (#124)
- Fix error in `expect_equal` functions (#123)
- Fix errors in `geom_tufteboxplot` and `stat_fivenumber` due to missing imported
  objects from ggplot2 (#117, #121)
- Fix text labels in top axis in `theme_economist` (#115)
- Update documentation on `geom_rangeframe`; it should be used with `coord_cartesian(clip="off")`. (#120)

# ggthemes 4.2.0

- Add `theme_clean()` (Thanks @konradzdeb, #105)
- Add `direction` argument to `scale_color_tableau()` and `scale_fill_tableau()`
  (Thanks @vadimus202, #112)

# ggthemes 4.1.1

- Fix bugs in `geom_rangeframe` and `geom_tufteboxplot` caused by
  failing to import `alpha`. (Thanks @flying-sheep, #110)

# ggthemes 4.1.0

- Add `type` argument to `scale_color_tableau` so that sequential and diverging
  palettes can be used in discrete scales. (Thanks @onesandzeroes, #108)
- Fix colors in "Purple" and "Blue-Teal" palettes
  in `tableau_color_pal()`. (Thanks @leonawicz, #109)

# ggthemes 4.0.1

- Fix bugs in `tableau_color_pal()`. Wrong colors in "Tableau 20" theme
  (Thanks @friskin, #95), and incorrect order of classic color palettes
  (Thanks @luca-scr, #96).
- Fix fatal bug in `theme_solarized()` and `solarized_rebase()`.
  (Thanks @mdodrill-usgs, #97)

# ggthemes 4.0.0

- Added palettes and based on current versions of Excel:
  `excel_pal_new()`, `scale_colour_excel_new()`, and `scale_fill_excel_new()`.
  Excel '97 based scales keep the same names.

- Added `theme_excel_new()` which is based on the chart defaults of current versions
  of Excel.

- Added Tableau 10 palettes and renamed old palettes
  in `tableau_color_pal()`, `scale_color_tableau()`, `scale_fill_tableau()`,
  and others. The continuous sequential and diverging palettes are improved
  by including more intermediate steps.

- Updated `theme_gdocs()` to current look.

- Updated `scale_color_gdocs()` and `fill_color_gdocs()` to current color.

- Added `scale_shapes_few()` and `few_shape_pal()` with a shape scale and
  palette from Stephen Few's "Show Me the Numbers".

- Removed `stata` argument from `scale_*_economist()` and `theme_economist()`.

- Changed the format of the `ggthemes_data` object.

- Changed behavior of `few_pal()`. If `n = 1`, use gray. If `n > 1` use non-gray
  colors.

- Changed `tremmel_shape_scale()` to use `alt = TRUE` by default

- Deprecated `tremmel_shape_scale()` argument `n3alt`. Use the `alt` argument instead.

- Added a pkgdown site.

- Removed vignette. Move all examples to man pages.

- Bugfix: Fix `theme_few()` (#91)

- Bugfix: Update themes to be consistent with `ggplot>=3.2.0`

# ggthemes 3.5.0

- Bugfix: Fix RGB colors in `scale_color_few()`, `scale_fill_few()`, and
  `few_pal()` (#89, @bpbraun)

- Update documentation to include mentions of the maximum number of values
  that discrete scales support (#85)

# ggthemes 3.4.2

- Bugfix: Fix example code in `theme_economist()`. Thanks @carlganz #81.
- Remove suggests dependencies: `reshape2`, `plyr`, `tidyverse`

# ggthemes 3.4.1

- Bugfix: Resolve duplicate palette names in `canva_palettes()`. Thanks @Eluvias (#78)

# ggthemes 3.4.0

- Add color palettes from canva.com: `canva_palettes()`, `canva_pal()`,
  `scale_colour_canva()`.

- Use `NEWS.md` instead of `NEWS`

- Update Economist examples to put y-axis on the right side.

# ggthemes 3.3.0

- Update themes to changes in ggplot 2.1.0.9000. Thanks @juliasilge (#71)

- `tufte_boxplot()` uses `position="dodge"` by default. Thanks @jgellar (#68)

- Bugfix: Fix errors in `geom_rangeframe()` in new version of ggplot2.
  Thanks @coulmont (#70)

# ggthemes 3.2.0

- Bugfix: In function `bank_slopes()`, remove methods `ao`, `gor`, and `lor`.
  These methods were not producing reliable results, and should not produce
  results much different than `ms` or `as`. If used, they will produce a
  warning, and `ms` will be used instead. (#68)

# ggthemes 3.1.0

- Add `ptol_pal()`, `scale_colour_ptol()`, and `scale_file_ptol()` based on
  Paul Tol's qualitative color palettes. Thanks @jmlondon. (#65)

# ggthemes 3.0.4

- Fix panel.grid.major.y colors for `theme_hc()`. Thanks @flying-sheep! (#64)

# ggthemes 3.0.3

- Bugfix: remove `lintr` tests that broke with new `testthat`.

# ggthemes 3.0.2

- Bugfix: export `ggthemes_data()`

# ggthemes 3.0.1

- Bugfix: Remove border around legends in `theme_gdocs()`.
  Thanks SandyMuspratt! Pull request #53.

- Bugfix: Remove border around legends in `theme_calc()`.

- Bugfix: Add colour and fill values to `theme_foundation()`. This restores
  its behavior to version 2.2.1. Fixes Issue #56.

# ggthemes 3.0.0

- For `geom_tufteboxplot()` and `GeomTufteboxplot`, option `median.type`
  supports only `line` and `point` options. Added option `whisker.type`
  which allows for whiskers to be specified by lines or points.

- Changed default stat for `geom_tufteboxplot()` to `stat_fivenumber()`.

- Added `theme_base()` and `theme_par()`

- Removed `scale_(x|y)_tufte()`. See issue #49

- `theme_foundation()` rewritten. Removed `use_sizes` argument.

- Import rather than depend on `ggplot2`

- Update geoms, scales, and themes to ggplot >= 2.0.0

# ggthemes 2.2.1

- bugfix: fix R CMD check notes due to change in how it handles non-base
  default packages: <https://developer.r-project.org/blosxom.cgi/R-devel/2015/06/29>

- bugfix: fix bad URLs

# ggthemes 2.2.0

- Added `theme_map()` from @hrbrmstr

# ggthemes 2.1.1

- bugfix: use title case in package title; refer to ggplot2 in title
- bugfix: fix non-escaped URLs in colorblind.R
- bugfix: fix broken URL in few.R
- bugfix: remove non-ascii characters in shapes.R
- bugfix: use `requireNamespace()` instead of `require()`

# ggthemes 2.1.0

- New theme and scale based on Highcharts JS: `scale_*_hc()`, `theme_hc()`.
  Thanks jbkunst!

# ggthemes 2.0.0

- New options for `geom_tufteboxplot()`. `median.type` takes values "point",
  "box", or "line". Option `usebox` is no longer supported, and equivalent to
  `median.type="box"`. Thanks weitzner! Issue #13, PR #19.

- All theme functions have `base_size` and `base_family` as first two arguments.
  This affects `theme_economist_white()`, `theme_excel()`,
  `theme_pander()`, `theme_solid()`, and `theme_tufte()`. Thanks ptoche! Issue #25.

- `theme_pander()`: Options `ff` and `fs` are deprecated; use
  `base_family` and `base_size` options instead, respectively.

# ggthemes 1.9.0

- added vignette

- added themes / scales based on factory defaults of pander package:
  `pander_palette()`, `scale_color_pander()`, `scale_fill_pander()`,
  `theme_pander()`. Thanks daroczig.

- added additional fill and gradient color scales: `scale_fill_fivethirtyeight()`,
  `scale_colour_gradient_tableau()`, `scale_fill_gradient_tableau()`,
  `scale_fill_continuous_tableau()`, `scale_colour_gradient2_tableau()`,
  `scale_fill_gradient2_tableau()`. Thanks bowerth.

# ggthemes 1.8.0

- added themes and color scale from fivethirtyeight.com: `theme_fivethirtyeight()`, `fivethirtyeight_pal()`, `scale_color_fivethirtyeight()`

# ggthemes 1.7.0

- added a new breaks algorithm: `scales_extended_range_breaks()`, `extended_range_breaks()`
- added scales which implement the breaks algorithm: `scale_x_tufte()`, `scale_y_tufte()`
- added new label format: `smart_digits()`, `smart_digits_format()`

# ggthemes 1.6.1

- fix bug in `theme_wsj()` (issue #17)

# ggthemes 1.6.0

- added `theme_solid()`

# ggthemes 1.5.1

- fix failures in R CMD check

# ggthemes 1.5.0

- added alternative Solarized theme: `theme_solarized_2()`
- `theme_solarized()`: adjusted the colors
- added LibreOffic Calc themes and palettes: `theme_calc()`, `calc_pal()`, `scale_fill_calc()`, `scale_colour_calc()`, `cacl_shape_pal()`, `scale_shape_calc()`
- added Google Docs themes and palettes: `theme_gdocs()`, `gdocs_pal()`, `scale_fill_gdocs()`, `scale_colour_gdocs()`
- fixed some examples

# ggthemes 1.4.0

- fix bug in default palettes of `scale_colour_excel()` and `scale_fill_excel()`.

# ggthemes 1.3.4

- added Tableau sequential colour palettes: `tableau_seq_gradient_pal()`, `scale_colour_gradient_tableau()`, `scale_fill_gradient_tableau()`.
- added Tableau diverging colour palettes: `tableau_div_gradient_pal()`, `scale_colour_gradient2_tableau()`, `scale_fill_gradient2_tableau()`.
- `tableau_colour_pal()`: added palette "cyclical

# ggthemes 1.3.3

- fix issue #11: error with fonts and `theme_wsj()` in Windows

# ggthemes 1.3.1

- `bank_slopes()` returns y/x aspect ratio to be compatible with `coord_fixed()`
- improved documentation

# ggthemes 1.3.0

- renamed `theme_excel2003()` to `theme_excel()`
- replace `scale_fill_excel2003()` and `scale_fill_excel10()` with `scale_fill_excel()`
- replaced `scale_colour_excel2003()` and `scale_colour_excel10()` with `scale_colour_excel()`
- replaced `excel2003_pal()` and `excel10_pal()` with `excel_pal()`
- renamed `theme_base()` to `theme_foundation()`

# ggthemes 1.2.0

- added colorblind scales: `colorblind_pal()`, `scale_*_colorblind()`.

# ggthemes 1.1.0

- added Wall Street Journal themes, palettes, scales: `theme_wsj()`, `wsj_pal()`,
  `scale_colour_wsj()`, and `scale_fill_wsj()`.
- added function `bank_slopes()` : methods for determining the optimal slope
  ratio.
- added `theme-foundation()`: a theme designed to be easy to extend into new
  themes.
- added NEWS file
