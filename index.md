# ggthemes [![ggthemes hex stickers, one per point colour palette, animated](reference/figures/stickers/ggthemes-theme-stickers.gif)](https://jrnold.github.io/ggthemes/)

[![R-CMD-check](https://github.com/jrnold/ggthemes/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jrnold/ggthemes/actions/workflows/R-CMD-check.yaml)
[![Code Coverage
Status](https://codecov.io/gh/jrnold/ggthemes/branch/main/graph/badge.svg)](https://app.codecov.io/github/jrnold/ggthemes?branch=main)
[![rstudio mirror
downloads](http://cranlogs.r-pkg.org/badges/ggthemes)](https://github.com/r-hub/cranlogs.app)
[![CRAN
status](https://www.r-pkg.org/badges/version/ggthemes)](https://CRAN.R-project.org/package=ggthemes)
[![lifecycle](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)

Some extra geoms, scales, and themes for
[ggplot](https://ggplot2.tidyverse.org/).

## Install

To install the stable version from CRAN,

``` r

install.packages('ggthemes', dependencies = TRUE)
```

Or, to install the development version from github, use the **devtools**
package,

``` r

library("devtools")
install_github(c("hadley/ggplot2", "jrnold/ggthemes"))
```

## How to use

For a quick tutorial, check out [Rafael Irizarry’s
book](http://rafalab.dfci.harvard.edu/dsbook/ggplot2.html#add-on-packages).

## Examples

``` r

library("ggplot2")
library("ggthemes")

mtcars2 <- within(mtcars, {
  vs <- factor(vs, labels = c("V-shaped", "Straight"))
  am <- factor(am, labels = c("Automatic", "Manual"))
  cyl  <- factor(cyl)
  gear <- factor(gear)
})

p1 <- ggplot(mtcars2) +
  geom_point(aes(x = wt, y = mpg, colour = gear)) +
  labs(
    title = "Fuel economy falls with weight",
    x = "Weight (1000 lbs)",
    y = "Fuel economy (mpg)",
    colour = "Gears"
  )

# `theme_map()` intentionally removes axes, so use geographic data rather than
# a scatterplot. `theme_solid()` is likewise intended to leave only geoms.
us_states <- map_data("state")
p_map <- ggplot(us_states, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = region), colour = "white", linewidth = 0.15) +
  coord_map("albers", lat0 = 39, lat1 = 45) +
  guides(fill = "none")

p_solid <- ggplot(mtcars2) +
  geom_point(aes(x = wt, y = mpg, colour = gear), size = 3) +
  guides(colour = "none")
```

[TABLE]

## Color palettes

Every colour palette shipped with ggthemes is shown below. Each row is
one palette; the swatches are in the order returned by the corresponding
palette function. This compact, data-derived gallery follows the
palette-overview approach used by
[ggpalettes](https://github.com/cran/ggpalettes) and the
one-palette-per-row display in
[sjPlot](https://github.com/strengejacke/sjPlot).

### General

[TABLE]

### Canva

[TABLE]

### Excel

[TABLE]

### Few

[TABLE]

### Highcharts

[TABLE]

### Numbers

[TABLE]

### Solarized

[TABLE]

### Stata

[TABLE]

### Tableau — discrete

[TABLE]

### Tableau — diverging

[TABLE]

### Tableau — sequential

[TABLE]

### Wall Street Journal

[TABLE]
