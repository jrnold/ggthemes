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
