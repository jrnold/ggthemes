# Economist sequential color scales

Color scales built from The Economist's equal-lightness color scales.
The `_c` scales are continuous; the `_ordinal` scales are discrete, for
ordered factors. See
[`scale_colour_economist()`](https://jrnold.github.io/ggthemes/reference/scale_economist.md)
for the unordered categorical scales.

## Usage

``` r
scale_colour_economist_c(hue = "blue", guide = "colourbar", ...)

scale_color_economist_c(hue = "blue", guide = "colourbar", ...)

scale_fill_economist_c(hue = "blue", guide = "colourbar", ...)

scale_colour_economist_ordinal(hue = "blue", ...)

scale_color_economist_ordinal(hue = "blue", ...)

scale_fill_economist_ordinal(hue = "blue", ...)
```

## Arguments

- hue:

  `character`. One of `"blue"`, `"cyan"`, `"green"`, `"yellow"`,
  `"olive"`, `"purple"`, `"gold"`, `"gray"`, or `"red"`.

- guide:

  Type of legend. Use `"colourbar"` for continuous color bars, or
  `"legend"` for discrete color legends.

- ...:

  Other arguments passed on to the underlying scale.

## See also

Other colour economist:
[`economist_pal()`](https://jrnold.github.io/ggthemes/reference/economist_pal.md),
[`economist_seq_pal()`](https://jrnold.github.io/ggthemes/reference/economist_seq_pal.md),
[`scale_colour_economist()`](https://jrnold.github.io/ggthemes/reference/scale_economist.md)
