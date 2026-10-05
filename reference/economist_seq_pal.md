# Economist sequential color palettes

The "equal lightness colour scales" of *The Economist visual styleguide*
(v1.2, 4 May 2017): six ordered steps for each of nine hues, running
darkest to lightest. Use them for ordered data. They come from the
paper's 2017 chart design, not the classic design of
[`economist_pal()`](https://jrnold.github.io/ggthemes/reference/economist_pal.md)
and
[`theme_economist()`](https://jrnold.github.io/ggthemes/reference/theme_economist.md).

## Usage

``` r
economist_seq_pal(hue = "blue")

economist_gradient_pal(hue = "blue")
```

## Arguments

- hue:

  A string, the hue of the color scale. One of `"blue"` (the default),
  `"cyan"`, `"green"`, `"yellow"`, `"olive"`, `"purple"`, `"gold"`,
  `"gray"`, or `"red"`.

## Value

`economist_seq_pal()` returns a palette function that takes the number
of colors `n` and returns the first `n` of the six hex colors for `hue`,
for use with
[`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).
`economist_gradient_pal()` returns a palette function that takes a
numeric vector `x` of values between 0 and 1 and returns hex colors
interpolated between those steps, for use with
[`ggplot2::continuous_scale()`](https://ggplot2.tidyverse.org/reference/continuous_scale.html).

## Details

`economist_seq_pal()` returns the six steps themselves, for discrete
ordered data. `economist_gradient_pal()` interpolates between them, for
continuous data.

## See also

Other color economist:
[`economist_pal()`](https://jrnold.github.io/ggthemes/reference/economist_pal.md),
[`scale_colour_economist()`](https://jrnold.github.io/ggthemes/reference/scale_economist.md),
[`scale_colour_economist_c()`](https://jrnold.github.io/ggthemes/reference/scale_economist_seq.md)

## Examples

``` r
library("scales")

# the six steps of one hue, darkest first
show_col(economist_seq_pal("blue")(6))

show_col(economist_seq_pal("red")(6))


# interpolated for continuous data
show_col(economist_gradient_pal("green")(seq(0, 1, length.out = 10)))
```
