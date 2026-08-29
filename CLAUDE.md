# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

ggthemes is an R package that provides extra themes, scales, and geoms for ggplot2. It replicates the look of plots from various sources including The Economist, FiveThirtyEight, Edward Tufte, Stephen Few, Stata, Excel, Wall Street Journal, Tableau, and more.

## Development Commands

### Building and Testing
```bash
# Full build (generates docs, site, and data)
make build

# Run package checks
make test
# Or directly:
Rscript -e 'devtools::check()'

# Generate documentation
make docs
# Or directly:
Rscript -e 'devtools::document()'

# Run linter
make lint
# Or directly:
Rscript -e 'devtools::lint()'

# Run code styling
make style
# Or directly:
./scripts/format
```

### Building Package Data
```bash
# Rebuild package data from YAML/XML theme definitions
make data
# Or directly:
Rscript data-raw/build.R
```

### Documentation Site
```bash
# Build pkgdown site
make site
# Or directly:
Rscript -e 'pkgdown::build_site()'
```

### README
```bash
# Regenerate README.md from README.Rmd
Rscript -e 'knitr::knit("README.Rmd", output = "README.md", quiet = TRUE)'
```

### Running Tests
```bash
# Run all tests
Rscript -e 'devtools::test()'

# Run specific test file
Rscript -e 'testthat::test_file("tests/testthat/test-economist.R")'
```

## Commit Conventions

This project uses [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) for commit messages.


### Format
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types
- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that don't affect code meaning (formatting, missing semicolons, etc.)
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **test**: Adding missing tests or correcting existing tests
- **chore**: Changes to build process or auxiliary tools

### Examples
```
feat: add solarized dark theme variant
fix: correct color palette for economist theme
docs: update README with new theme examples
test: add visual regression tests for tufte theme
chore: update pkgdown configuration
```

## NEWS.md

For user-facing changes update `NEWS.md` when commiting.

## Architecture

### Code Organization

**R/**: Main source files organized by theme/functionality
- Each major theme has its own file (e.g., `economist.R`, `tufte.R`, `fivethirtyeight.R`)
- Each file typically contains:
  - Color palette function (e.g., `economist_pal()`)
  - Scale functions for both color/fill (e.g., `scale_color_economist()`, `scale_fill_economist()`)
  - Theme function (e.g., `theme_economist()`)
- `utils.R`: Shared utilities including `check_pal_n()`, `get_colors()`, and the `%||%` operator
- `geom-*.R`: Custom geoms like `geom_rangeframe()` and `geom_tufteboxplot()`
- `stat-*.R`: Custom stats like `stat_fivenumber()`
- `base.R`: Contains `theme_foundation()`, the base theme that many other themes build upon

**data-raw/**: Data generation and theme definitions
- `build.R`: Master script that loads all theme data from YAML/XML files and builds the `ggthemes_data` object
- `theme-data/`: YAML and XML files defining colors, shapes, and palettes for each theme
- The build process converts these into tibbles stored in `ggthemes_data`

**ggthemes_data Structure**: A named list containing theme-specific data (colors, palettes, shapes) accessed throughout the package. Each theme has its own nested structure within this object.

### Theme Implementation Pattern

Most themes follow this structure:

1. **Palette function** (`*_pal()`): Returns a function that generates n colors
   - Typically checks n against max_n using `check_pal_n()`
   - Returns colors from `ggthemes_data` based on the requested number

2. **Scale functions**: Wrappers around ggplot2's discrete_scale() or continuous_scale()
   - `scale_color_*()` and `scale_colour_*()` (both spellings supported)
   - `scale_fill_*()`

3. **Theme function** (`theme_*()`): Defines complete plot appearance
   - Usually starts with `theme_foundation()` or another base theme
   - Customizes elements using `theme()` with `element_*()` functions

### Data Loading System

The `data-raw/build.R` script:
1. Creates a new environment `ggthemes_data`
2. For each theme, defines a `load_*()` function that:
   - Reads YAML/XML from `data-raw/theme-data/`
   - Converts to tibbles using `map_dfr()` and `as_tibble()`
   - For shapes, converts UTF-8 characters to pch codes
3. Saves the final list using `usethis::use_data(ggthemes_data, overwrite = TRUE)`

### Testing Strategy

Tests use:
- **vdiffr**: Visual regression testing via `expect_doppelganger()` helper in `helper-vdiffr.R`
- Standard testthat expectations for palette functions
- Tests are organized by theme/feature (one test file per major component)

### Code Style

Code sytle is enforced by the the [air](https://tidyverse.org/blog/2025/02/air/) and [lintr](https://lintr.r-lib.org/) packages.

- Generally follows the [tidyverse style](https://style.tidyverse.org/).
- Line length of 120
- `air` package configuration: `air.toml`.
- `lintr` package configuration: `.lintr`

### Spelling

Check spelling using the [spelling](https://docs.ropensci.org/spelling/) package.

```bash
# Run spell check
Rscript tests/spelling.R

# Update wordlist interactively (adds new words found in documentation)
Rscript -e 'spelling::update_wordlist()'
```

The custom wordlist is stored in `inst/WORDLIST` and contains project-specific terms like:
- Package names (ggplot, vdiffr, pkgdown)
- Theme names (fivethirtyeight, solarized, stata)
- Author names and proper nouns
- Technical terms specific to this project

When spell check finds new valid words, add them to `inst/WORDLIST` using `spelling::update_wordlist()`.

## Key Concepts

**theme_foundation()**: Located in `base.R`, this is the minimal base theme that other themes extend. It sets basic defaults for all ggplot2 elements.

**Color Extraction**: The `get_colors()` utility in `utils.R` filters `ggthemes_data` by color names and extracts hex values.

**Shape Encoding**: Shapes use negative integers as pch codes, converted from UTF-8 using `utf_8_to_pch()` in `data-raw/build.R`.

**README Generation**: README.md is auto-generated from README.Rmd and should never be edited directly. The first line of README.md indicates this.
