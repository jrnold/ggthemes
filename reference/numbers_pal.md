# Apple Numbers color palettes (discrete)

Color palettes used by charts in Apple Numbers. Each palette provides
the six series colors that Numbers assigns to a chart's data series, in
order.

## Usage

``` r
numbers_pal(palette = "Classic")
```

## Arguments

- palette:

  Palette name. One of `"Blue Green"`, `"Blue Violet"`, `"Blue"`,
  `"Brown"`, `"Classic"`, `"Earth Tone"`, `"Gray"`, `"Green"`, `"Jade"`,
  `"Mid Century"`, `"Showroom"`, `"Spectrum"` . The default,
  `"Classic"`, is the palette Numbers itself uses by default.

## See also

Other colour numbers:
[`scale_fill_numbers()`](http://jrnold.github.io/ggthemes/reference/scale_numbers.md)

## Examples

``` r
library("scales")

show_col(numbers_pal()(6))

show_col(numbers_pal("Spectrum")(6))
```
