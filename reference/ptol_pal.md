# Color Palettes from Paul Tol's "Colour Schemes"

**\[deprecated\]**

`ptol_pal()` was deprecated in ggthemes 7.0.0. Use the
[khroma](https://CRAN.R-project.org/package=khroma) package instead,
which tracks Paul Tol's color schemes as he revises them.

This palette is the 12-color qualitative scheme from Tol's 2012
technical note, and has not followed the revisions he has made since.
His current schemes are at <https://sronpersonalpages.nl/~pault/>; the
closest successor to this palette is `khroma::colour("muted")`.

Qualitative color palettes from Paul Tol, ["Colour
Schemes"](https://sronpersonalpages.nl/~pault/).

## Usage

``` r
ptol_pal()
```

## Value

A palette function. It takes the number of colors `n` and returns a
character vector of `n` hex colors, and can be used as the `palette`
argument of
[`discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).

## Details

Incorporation of the palette into an R package was originally inspired
by Peter Carl's [Paul Tol 21 Gun
Salute](https://tradeblotter.wordpress.com/2013/02/28/the-paul-tol-21-color-salute/)

## References

Paul Tol. 2012. "Colour Schemes." SRON Technical Note,
SRON/EPS/TN/09-002.
<https://sronpersonalpages.nl/~pault/data/colourschemes.pdf>

## See also

Other color ptol:
[`scale_colour_ptol()`](https://jrnold.github.io/ggthemes/reference/scale_ptol.md)

## Examples

``` r
library("scales")

show_col(ptol_pal()(6))
#> Warning: `ptol_pal()` was deprecated in ggthemes 7.0.0.
#> ℹ This palette is the 12-colour qualitative scheme from Paul Tol's 2012
#>   technical note. He has revised his schemes since; the current ones are at
#>   <https://sronpersonalpages.nl/~pault/>.
#> ℹ The khroma package tracks those revisions. The closest successor to this
#>   palette is `khroma::colour("muted")`, or `khroma::scale_colour_muted()` for a
#>   ggplot2 scale.

show_col(ptol_pal()(4))

show_col(ptol_pal()(12))
```
