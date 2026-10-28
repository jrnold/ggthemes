# Format numbers with automatic number of digits (deprecated)

**\[deprecated\]**

`smart_digits()` and `smart_digits_format()` are deprecated. Use
[`scales::label_number()`](https://scales.r-lib.org/reference/label_number.html),
which also picks the accuracy from the smallest gap between values.

## Usage

``` r
smart_digits(x, ...)

smart_digits_format(x, ...)
```

## Arguments

- x:

  A numeric vector to format.

- ...:

  Parameters passed to
  [`base::format()`](https://rdrr.io/r/base/format.html).

## Value

A character vector. `smart_digits_format()` returns a function with a
single argument `x`, a numeric vector, that returns a character vector.

## References

Josh O'Brien,
<https://stackoverflow.com/questions/23169938/select-accuracy-to-display-additional-axis-breaks/23171858#23171858>.

## Author

Josh O'Brien, Baptiste Auguie, Jeffrey B. Arnold

## Examples

``` r
# Use scales::label_number() instead
scales::label_number()(c(0.1234, 0.5, 1.25))
#> [1] "0.12" "0.50" "1.25"

library(ggplot2)

ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  scale_y_continuous(labels = scales::label_number())
```
