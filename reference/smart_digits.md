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

Josh O'Brien, Baptise Auguie, Jeffrey B. Arnold
