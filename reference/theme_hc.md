# Highcharts Theme

Themes based on [Highcharts](https://www.highcharts.com/) plots.

## Usage

``` r
theme_hc(
  base_size = 12,
  base_family = "sans",
  style = c("default", "default_dark", "darkunica", "grid_light", "sand_signika"),
  bgcolor = NULL
)
```

## Arguments

- base_size:

  base font size, given in pts.

- base_family:

  base font family

- style:

  The Highcharts theme to use. One of `"default"`, `"default_dark"`,
  `"darkunica"`, `"grid_light"`, `"sand_signika"` .

- bgcolor:

  Deprecated

## Details

Only the Highcharts themes that restyle the chart itself get a `style`
here. The `"high-contrast"`, `"avocado"` and `"sunset"` themes shipped
with Highcharts 13 change nothing but the series colours, so they are
available through
[`hc_pal()`](https://jrnold.github.io/ggthemes/reference/hc_pal.md)
alone; combine them with `theme_hc("default")` or
`theme_hc("default_dark")`.

Highcharts pairs several of these themes with a web font (`darkunica`
with Unica One, `grid_light` with Dosis, `sand_signika` with Signika).
Those are not requested here, since the font may not be installed; pass
`base_family` to use one.

## References

<https://www.highcharts.com/demo/highcharts/line-chart>

## Examples

``` r
library("ggplot2")

p <- ggplot(mtcars) +
  geom_point(aes(
    x = wt,
    y = mpg,
    colour = factor(gear)
  )) +
  facet_wrap(~am)
p + theme_hc() + scale_colour_hc()

p + theme_hc(style = "darkunica") + scale_colour_hc("darkunica")

p + theme_hc(style = "grid_light") + scale_colour_hc("grid_light")

p + theme_hc(style = "default_dark") + scale_colour_hc("high_contrast_dark")


dtemp <- data.frame(
  months = factor(rep(substr(month.name, 1, 3), 4), levels = substr(month.name, 1, 3)),
  city = rep(c("Tokyo", "New York", "Berlin", "London"), each = 12),
  temp = c(
    7.0,
    6.9,
    9.5,
    14.5,
    18.2,
    21.5,
    25.2,
    26.5,
    23.3,
    18.3,
    13.9,
    9.6,
    -0.2,
    0.8,
    5.7,
    11.3,
    17.0,
    22.0,
    24.8,
    24.1,
    20.1,
    14.1,
    8.6,
    2.5,
    -0.9,
    0.6,
    3.5,
    8.4,
    13.5,
    17.0,
    18.6,
    17.9,
    14.3,
    9.0,
    3.9,
    1.0,
    3.9,
    4.2,
    5.7,
    8.5,
    11.9,
    15.2,
    17.0,
    16.6,
    14.2,
    10.3,
    6.6,
    4.8
  )
)

ggplot(dtemp, aes(x = months, y = temp, group = city, color = city)) +
  geom_line() +
  geom_point(size = 1.1) +
  ggtitle("Monthly Average Temperature") +
  theme_hc() +
  scale_colour_hc()


ggplot(dtemp, aes(x = months, y = temp, group = city, color = city)) +
  geom_line() +
  geom_point(size = 1.1) +
  ggtitle("Monthly Average Temperature") +
  theme_hc(style = "darkunica") +
  scale_colour_hc("darkunica")
```
