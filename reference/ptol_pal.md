# Color Palettes from Paul Tol's "Colour Schemes"

Qualitative color palettes from Paul Tol, ["Colour
Schemes"](https://sronpersonalpages.nl/~pault/).

## Usage

``` r
ptol_pal()
```

## Details

Incorporation of the palette into an R package was originally inspired
by Peter Carl's \[Paul Tol 21 Gun
Salute\](https://tradeblotter.wordpress.com/2013/02/28/the-paul-tol-21-color-salute/)

## References

Paul Tol. 2012. "Colour Schemes." SRON Technical Note,
SRON/EPS/TN/09-002.
<https://sronpersonalpages.nl/~pault/data/colourschemes.pdf>

## See also

Other colour ptol:
[`scale_colour_ptol()`](http://jrnold.github.io/ggthemes/reference/scale_ptol.md)

## Examples

``` r
library("scales")

show_col(ptol_pal()(6))

show_col(ptol_pal()(4))

show_col(ptol_pal()(12))
```
