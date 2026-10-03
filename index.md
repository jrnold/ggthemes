# ggthemes [![Animated ggthemes hex stickers, cycling through stickers drawn in the package's themes](reference/figures/stickers/ggthemes-theme-stickers.gif)](https://jrnold.github.io/ggthemes/)

[![R-CMD-check](https://github.com/jrnold/ggthemes/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jrnold/ggthemes/actions/workflows/R-CMD-check.yaml)
[![Code Coverage
Status](https://codecov.io/gh/jrnold/ggthemes/branch/main/graph/badge.svg)](https://app.codecov.io/github/jrnold/ggthemes?branch=main)
[![CRAN
downloads](https://cranlogs.r-pkg.org/badges/ggthemes)](https://www.r-pkg.org/pkg/ggthemes)
[![CRAN
status](https://www.r-pkg.org/badges/version/ggthemes)](https://CRAN.R-project.org/package=ggthemes)
[![lifecycle](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)

ggthemes adds themes, scales and geoms to
[ggplot2](https://ggplot2.tidyverse.org/) that reproduce the look of
well-known publications and software, and of the graphics advocated by
Edward Tufte and Stephen Few:

- **Themes** after *The Economist*, *The Wall Street Journal*,
  FiveThirtyEight, Excel, LibreOffice Calc, Google Docs, Highcharts,
  Apple Numbers, Stata, Solarized, base R graphics and more.
- **Color, shape and linetype scales and palettes** to match, including
  colorblind-safe and Tableau palettes. See the [palette
  gallery](https://jrnold.github.io/ggthemes/articles/palettes.html).
- **Geoms** for Tufte’s range frames and minimal box plots, and tools
  for [banking to
  45°](https://jrnold.github.io/ggthemes/reference/bank_slopes.html) to
  choose a plot’s aspect ratio.

![The same scatter plot of fuel economy against car weight drawn four
ways: with theme_economist(), theme_fivethirtyeight(), theme_wsj() and
theme_solarized(), each with its matching color
scale.](reference/figures/README-hero-1.png)

## Installation

Install the released version from CRAN:

``` r

install.packages("ggthemes")
```

Or the development version from GitHub:

``` r

# install.packages("pak")
pak::pak("jrnold/ggthemes")
```

## Themes

Every theme is shown below with its matching color scale, where it has
one. Each figure links to the theme’s reference page.

Data and base plots used in the examples

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

A sample of the color palettes is shown below. The [palette
gallery](https://jrnold.github.io/ggthemes/articles/palettes.html) shows
every palette in the package.

![Swatches of eight palettes: colorblind, Economist, FiveThirtyEight,
Few, Solarized, Stata, Tableau 10 and Wall Street
Journal.](reference/figures/README-palettes-1.png)

## Geoms

[`geom_rangeframe()`](https://jrnold.github.io/ggthemes/reference/geom_rangeframe.md)
draws Tufte’s range frame, axis lines that span only the range of the
data.
[`geom_tufteboxplot()`](https://jrnold.github.io/ggthemes/reference/geom_tufteboxplot.md)
draws his minimal box plot.

``` r

ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  geom_rangeframe() +
  coord_cartesian(clip = "off") +
  labs(x = "Weight (1000 lbs)", y = "Miles per gallon") +
  theme_tufte()

ggplot(mtcars, aes(factor(cyl), mpg)) +
  geom_tufteboxplot() +
  labs(x = "Cylinders", y = "Miles per gallon") +
  theme_tufte()
```

![Scatter plot of fuel economy against weight with theme_tufte(), whose
axis lines span only the range of the
data.](reference/figures/README-geoms-1.png)![Tufte-style box plots of
fuel economy by number of cylinders: a point for the median and lines
for the whiskers.](reference/figures/README-geoms-2.png)

## Learn more

- The [reference pages](https://jrnold.github.io/ggthemes/reference/)
  document every theme, scale, palette and geom, with examples.
- The [palette
  gallery](https://jrnold.github.io/ggthemes/articles/palettes.html)
  shows every color palette.
- For a tutorial that uses ggthemes, see the [add-on packages
  section](http://rafalab.dfci.harvard.edu/dsbook/ggplot2.html#add-on-packages)
  of Rafael Irizarry’s *Introduction to Data Science*.
