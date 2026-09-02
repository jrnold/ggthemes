# Excel 97 ugly color palettes (discrete)

The color palettes used in Microsoft Excel 97 (and up until Excel 2007).
Use this for that classic ugly look and feel. For ironic purposes only.
3D bars and pies not included. Please never use this color palette.

## Usage

``` r
excel_pal(line = TRUE)
```

## Arguments

- line:

  If `TRUE`, use the palette for lines and points. Otherwise, use the
  palette for area.

## See also

Other colour excel:
[`excel_new_pal()`](https://jrnold.github.io/ggthemes/reference/excel_new_pal.md),
[`scale_colour_excel_new()`](https://jrnold.github.io/ggthemes/reference/scale_excel_new.md),
[`scale_fill_excel()`](https://jrnold.github.io/ggthemes/reference/scale_excel.md)

## Examples

``` r
library("scales")

show_col(excel_pal()(7))

show_col(excel_pal(line = FALSE)(7))
```
