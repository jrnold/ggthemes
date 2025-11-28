# Tableau Shape Palettes (discrete)

Shape palettes used by [Tableau](https://www.tableau.com/).

## Usage

``` r
tableau_shape_pal(palette = c("default", "filled", "proportions"))
```

## Arguments

- palette:

  Palette name.

## Details

Not all shape palettes in Tableau are supported. Additionally, these
palettes are not exact, and use the best unicode character for the shape
palette.

Since these palettes use unicode characters, their look may depend on
the font being used, and not all characters may be available.

Shape palettes in Tableau are used to expose images for use a markers in
charts, and thus are sometimes groupings of closely related symbols.

## See also

Other shape tableau:
[`scale_shape_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_shape_tableau.md)

## Examples

``` r
if (FALSE) { # \dontrun{
  # need to set a font containing these values
  show_shapes(tableau_shape_pal()(5))
} # }
```
