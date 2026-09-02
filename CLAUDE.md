# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with code in this repository.

## Overview

ggthemes is an R package that provides extra themes, scales, and geoms
for ggplot2. It replicates the look of plots from various sources
including The Economist, FiveThirtyEight, Edward Tufte, Stephen Few,
Stata, Excel, Wall Street Journal, Tableau, and more.

## R package conventions

General R package practice is **not** documented here. The `r-lib`
skills (Posit, `posit-dev/skills`) are authoritative and take
precedence:

- **`r-package-development`** — devtools/roxygen2 workflow, test
  placement, documentation rules, `_pkgdown.yml` upkeep, and `NEWS.md`
  bullet style.
- **`testing-r-packages`** — testthat 3e structure, expectations,
  fixtures, snapshots, mocking, `withr` cleanup.
- **`cran-extrachecks`** — pre-submission checks beyond
  `devtools::check()`.
- **`lifecycle`**, **`cli`** — deprecation staging and console
  messaging.

This package is testthat edition 3 (`testthat (>= 3.2.0)`) and has a
`_pkgdown.yml`, so those skills apply as written. Where existing code
diverges from them, the skill is the target — follow it for new and
edited code.

Only project-specific facts live below.

## Development Commands

The `Makefile` is the entry point; prefer these over bare `Rscript`
calls, since several targets chain steps (`build` regenerates docs,
site, and data).

``` bash
make build   # Full build: docs, site, and data
make test    # devtools::check()
make docs    # devtools::document()
make lint    # lintr
make style   # ./scripts/format (air)
make data    # Rebuild package data (see below)
make site    # pkgdown::build_site()
```

### Building Package Data

``` bash
# Rebuild package data from YAML/XML theme definitions
make data
# Or directly:
Rscript data-raw/build.R
```

### README

README.md is auto-generated from README.Rmd and must never be edited
directly (the first line of README.md says so).

``` bash
Rscript -e 'knitr::knit("README.Rmd", output = "README.md", quiet = TRUE)'
```

## Commit Conventions

Update `NEWS.md` for any user-facing change as part of the commit that
makes it.

This project uses [Conventional
Commits](https://www.conventionalcommits.org/en/v1.0.0/) for commit
messages.

### Format

    <type>[optional scope]: <description>

    [optional body]

    [optional footer(s)]

### Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that don’t affect code meaning (formatting, missing
  semicolons, etc.)
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **test**: Adding missing tests or correcting existing tests
- **chore**: Changes to build process or auxiliary tools

### Examples

    feat: add solarized dark theme variant
    fix: correct color palette for economist theme
    docs: update README with new theme examples
    test: add visual regression tests for tufte theme
    chore: update pkgdown configuration

## Architecture

### Code Organization

**R/**: Main source files organized by theme/functionality - Each major
theme has its own file (e.g., `economist.R`, `tufte.R`,
`fivethirtyeight.R`) - Each file typically contains: - Color palette
function (e.g.,
[`economist_pal()`](https://jrnold.github.io/ggthemes/reference/economist_pal.md)) -
Scale functions for both color/fill (e.g.,
[`scale_color_economist()`](https://jrnold.github.io/ggthemes/reference/scale_economist.md),
[`scale_fill_economist()`](https://jrnold.github.io/ggthemes/reference/scale_economist.md)) -
Theme function (e.g.,
[`theme_economist()`](https://jrnold.github.io/ggthemes/reference/theme_economist.md)) -
`utils.R`: Shared utilities including `check_pal_n()`, `get_colors()`,
and the `%||%` operator - `geom-*.R`: Custom geoms like
[`geom_rangeframe()`](https://jrnold.github.io/ggthemes/reference/geom_rangeframe.md)
and
[`geom_tufteboxplot()`](https://jrnold.github.io/ggthemes/reference/geom_tufteboxplot.md) -
`stat-*.R`: Custom stats like
[`stat_fivenumber()`](https://jrnold.github.io/ggthemes/reference/stat_fivenumber.md) -
`base.R`: Contains
[`theme_foundation()`](https://jrnold.github.io/ggthemes/reference/theme_foundation.md),
the base theme that many other themes build upon

**data-raw/**: Data generation and theme definitions - `build.R`: Master
script that loads all theme data from YAML/XML files and builds the
`ggthemes_data` object - `theme-data/`: YAML and XML files defining
colors, shapes, and palettes for each theme - The build process converts
these into tibbles stored in `ggthemes_data`

**ggthemes_data Structure**: A named list containing theme-specific data
(colors, palettes, shapes) accessed throughout the package. Each theme
has its own nested structure within this object.

### Theme Implementation Pattern

Most themes follow this structure:

1.  **Palette function** (`*_pal()`): Returns a function that generates
    n colors
    - Typically checks n against max_n using `check_pal_n()`
    - Returns colors from `ggthemes_data` based on the requested number
2.  **Scale functions**: Wrappers around ggplot2’s discrete_scale() or
    continuous_scale()
    - `scale_color_*()` and `scale_colour_*()` (both spellings
      supported)
    - `scale_fill_*()`
3.  **Theme function** (`theme_*()`): Defines complete plot appearance
    - Usually starts with
      [`theme_foundation()`](https://jrnold.github.io/ggthemes/reference/theme_foundation.md)
      or another base theme
    - Customizes elements using `theme()` with `element_*()` functions

### Data Loading System

The `data-raw/build.R` script: 1. Creates a new environment
`ggthemes_data` 2. For each theme, defines a `load_*()` function that: -
Reads YAML/XML from `data-raw/theme-data/` - Converts to tibbles using
`map_dfr()` and `as_tibble()` - For shapes, converts UTF-8 characters to
pch codes 3. Saves the final list using
`usethis::use_data(ggthemes_data, overwrite = TRUE)`

### Testing Strategy

Test files are organized **per theme**, not strictly per `R/` source
file, so a single `test-tableau.R` covers the palettes, scales, and
theme together.

Three complementary layers:

- **Structural assertions** — the bulk of the suite. Checks against the
  theme object itself (`expect_s3_class(theme_economist(), "theme")`,
  `expect_equal(thm$text$family, "mono")`) and against palette functions
  (length, `max_n`, hex validity, error and warning behaviour). These
  catch what someone thought to assert on, and nothing else.
- **Visual regression (vdiffr)** — every exported theme has an
  `expect_doppelganger()` baseline built from the shared
  `theme_test_plot()` figure in `helper-plots.R`, plus swatch-grid
  baselines for the Tableau ordered and regular palette families and for
  the package’s discrete palettes. Baselines live in
  `tests/testthat/_snaps/`.
- **Palette property assertions** — `test-palettes.R` asserts invariants
  over whole palette families rather than one palette at a time: valid
  hex, no duplicate colours, stable lengths (snapshotted), monotone
  lightness for sequential ramps, no out-of-family colour, and
  per-channel monotonicity for grey ramps. These are device-independent
  and name the offending palette and index, so they diagnose better than
  an SVG diff. Palette-specific regressions stay in `test-tableau.R`.

#### vdiffr and when it runs

`vdiffr` is in `Suggests`, so `helper-vdiffr.R` follows ggplot2’s
convention: it aliases
[`vdiffr::expect_doppelganger()`](https://vdiffr.r-lib.org/reference/expect_doppelganger.html)
when vdiffr is installed, and otherwise skips — unless
`VDIFFR_RUN_TESTS="true"`, in which case a missing vdiffr is an error
rather than a silent loss of coverage. The R-CMD-check workflow sets
that variable on the `release` R version only.

Visual tests **do** run on GitHub Actions, because
`r-lib/actions/setup-r` exports `NOT_CRAN=true`. They **do not** run on
CRAN, because vdiffr delegates to
`testthat::expect_snapshot_file(cran = FALSE)`. Both behaviours are
intended; neither requires configuration in this repository.

**Never accept a changed baseline without looking at it.** Because this
package’s entire output is images, a baseline regenerated from buggy
output locks the bug in and turns the suite green. Review before
accepting.

### Code Style

Enforced by [air](https://tidyverse.org/blog/2025/02/air/) and
[lintr](https://lintr.r-lib.org/); generally [tidyverse
style](https://style.tidyverse.org/).

- Line length of 120 (wider than the tidyverse default)
- `air` configuration: `air.toml`
- `lintr` configuration: `.lintr`

### Spelling

Check spelling using the [spelling](https://docs.ropensci.org/spelling/)
package.

``` bash
# Run spell check
Rscript tests/spelling.R

# Update wordlist interactively (adds new words found in documentation)
Rscript -e 'spelling::update_wordlist()'
```

The custom wordlist is stored in `inst/WORDLIST` and contains
project-specific terms like: - Package names (ggplot, vdiffr, pkgdown) -
Theme names (fivethirtyeight, solarized, stata) - Author names and
proper nouns - Technical terms specific to this project

When spell check finds new valid words, add them to `inst/WORDLIST`
using
[`spelling::update_wordlist()`](https://docs.ropensci.org/spelling//reference/wordlist.html).

## Key Concepts

**theme_foundation()**: Located in `base.R`, this is the minimal base
theme that other themes extend. It sets basic defaults for all ggplot2
elements.

**Color Extraction**: The `get_colors()` utility in `utils.R` filters
`ggthemes_data` by color names and extracts hex values.

**Shape Encoding**: Shapes use negative integers as pch codes, converted
from UTF-8 using `utf_8_to_pch()` in `data-raw/build.R`.
