# Scales for shapes from "Show Me the Numbers"

`scale_shape_few()` maps discrete variables to up to five easily
discernible shapes. It is based on the shape palette suggested in Few
(2012).

## Usage

``` r
scale_shape_few(...)
```

## Arguments

- ...:

  Common
  [`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html)
  parameters.

## Value

A ggplot2 scale object.

## References

Few, S. (2012) *Show Me the Numbers: Designing Tables and Graphs to
Enlighten*, Analytics Press, p. 208.

## See also

`scale_shape_few()` for the shape palette that this scale uses.

## Examples

``` r
library("ggplot2")

ggplot(mtcars, aes(x = wt, y = mpg, shape = factor(gear))) +
  geom_point(size = 3) +
  scale_shape_few()
```
