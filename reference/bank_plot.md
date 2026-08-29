# Bank a Plot's Own Data to 45 Degrees

A convenience wrapper around
[`bank_slopes`](http://jrnold.github.io/ggthemes/reference/bank_slopes.md)
that extracts `x`/`y` directly from an already-specified `ggplot`, so
you do not have to separately reconstruct the plotted vectors by hand.
It builds `plot` with
[`ggplot_build`](https://ggplot2.tidyverse.org/reference/ggplot_build.html),
computes the banking ratio from one layer's fully resolved data (i.e.
after stats, position adjustments, and faceting have been applied), and
returns
`plot + `[`coord_fixed`](https://ggplot2.tidyverse.org/reference/coord_fixed.html)`(ratio = ...)`.

## Usage

``` r
bank_plot(
  plot,
  method = c("ms", "as", "ao", "was"),
  cull = FALSE,
  layer = 1,
  ...
)
```

## Arguments

- plot:

  A `ggplot` object.

- method, cull, ...:

  Passed to
  [`bank_slopes`](http://jrnold.github.io/ggthemes/reference/bank_slopes.md).

- layer:

  Integer. Which layer of `plot` to extract `x`/ `y` from. Defaults to
  the first layer.

## Value

The `plot`, with
[`coord_fixed`](https://ggplot2.tidyverse.org/reference/coord_fixed.html)
added.

## Details

Segments are never averaged across a group or facet panel boundary:
slopes are computed within each combination of `group` and `PANEL` and
then combined, so a line plot with multiple series (or facets) is banked
correctly rather than picking up spurious slopes between the end of one
line and the start of the next.

Note that
[`coord_fixed`](https://ggplot2.tidyverse.org/reference/coord_fixed.html)
applies a single ratio to every panel, so faceted plots are banked using
the combined data from all panels rather than a ratio tailored to each
one individually.

## See also

[`bank_slopes`](http://jrnold.github.io/ggthemes/reference/bank_slopes.md)

## Examples

``` r
library("ggplot2")
x <- seq_along(sunspot.year)
y <- as.numeric(sunspot.year)
p <- ggplot(data.frame(x = x, y = y), aes(x = x, y = y)) +
  geom_line()
bank_plot(p)
```
