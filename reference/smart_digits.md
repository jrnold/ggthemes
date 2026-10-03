# Format numbers with automatic number of digits

Format numbers with automatic number of digits

## Usage

``` r
smart_digits(x, ...)

smart_digits_format(x, ...)
```

## Arguments

- x:

  A numeric vector to format

- ...:

  Parameters passed to [`format()`](https://rdrr.io/r/base/format.html)

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
smart_digits(c(0.1234, 0.5, 1.25))
#> [1] "0" "0" "1"

smart_digits(c(1234.5678, 2000, 10000))
#> [1] " 1000" " 2000" "10000"

# A labelling function for use in a scale
library("ggplot2")

ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  scale_y_continuous(labels = smart_digits_format())
```
