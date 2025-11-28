# Clean ggplot theme

Clean ggplot theme with no panel background, black axis lines and grey
fill colour for chart elements.

## Usage

``` r
theme_clean(base_size = 12, base_family = "sans")
```

## Arguments

- base_size:

  Base font size.

- base_family:

  Base font family.

## See also

Other themes:
[`theme_base()`](http://jrnold.github.io/ggthemes/reference/theme_base.md),
[`theme_foundation()`](http://jrnold.github.io/ggthemes/reference/theme_foundation.md),
[`theme_igray()`](http://jrnold.github.io/ggthemes/reference/theme_igray.md),
[`theme_par()`](http://jrnold.github.io/ggthemes/reference/theme_par.md),
[`theme_solid()`](http://jrnold.github.io/ggthemes/reference/theme_solid.md)

## Author

Konrad Zdeb <name.surname@me.com>

## Examples

``` r
library("ggplot2")
p <- ggplot(mtcars, aes(x = wt, y = mpg, colour = factor(gear))) +
  geom_point() +
  facet_wrap(~am) +
  geom_smooth(method = "lm", se = FALSE) +
  theme_clean()
p
#> `geom_smooth()` using formula = 'y ~ x'
```
