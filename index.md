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
    title = "Fuel economy declines as weight increases",
    subtitle = "(1973-74)",
    caption = "Data from the 1974 Motor Trend US magazine.",
    x = "Weight (1000 lbs)",
    y = "Fuel economy (mpg)",
    colour = "Gears"
  )
```

``` r

p1 +
  scale_color_calc() +
  theme_calc()
```

![](reference/figures/README-theme_calc-1.png)

``` r

p1 + theme_clean()
```

![](reference/figures/README-theme_clean-1.png)

``` r

p1 + theme_economist() +
  scale_colour_economist()
```

![](reference/figures/README-theme_economist-1.png)

``` r

p1 + theme_excel() +
  scale_colour_excel()
```

![](reference/figures/README-theme_excel-1.png)

``` r

p1 + theme_excel_new() +
  scale_colour_excel_new()
```

![](reference/figures/README-theme_excel_new-1.png)

``` r

p1 + theme_igray()
```

![](reference/figures/README-theme_igray-1.png)

``` r

p1 + theme_par()
```

![](reference/figures/README-theme_par-1.png)

``` r

p1 + theme_fivethirtyeight()
```

![](reference/figures/README-theme_fivethirtyeight-1.png)

``` r

p1 + theme_few() +
  scale_colour_few()
```

![](reference/figures/README-theme_few-1.png)

``` r

p1 + theme_solarized() +
  scale_colour_solarized()
```

![](reference/figures/README-theme_solarized-1.png)

``` r

p1 + theme_solarized(light=FALSE) +
  scale_colour_solarized()
```

![](reference/figures/README-theme_solarized_dark-1.png)

``` r

p1 + theme_solid()
```

![](reference/figures/README-theme_solid-1.png)

``` r

p1 + theme_tufte()
```

![](reference/figures/README-theme_stata-1.png)

``` r

p1 + theme_wsj(base_size = 8) + scale_color_wsj()
```

![](reference/figures/README-theme_wsj-1.png)

``` r

p1 + scale_color_colorblind()
```

![](reference/figures/README-scale_colorblind-1.png)

``` r

p1 + scale_color_tableau()
```

![](reference/figures/README-scale_color_tableau-1.png)

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
