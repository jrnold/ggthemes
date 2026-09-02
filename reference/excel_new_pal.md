# Excel (current versions) color palettes (discrete)

Color palettes used by current versions of Microsoft Office and Excel.

## Usage

``` r
excel_new_pal(theme = "Office")
```

## Arguments

- theme:

  The name of the Office theme or color theme (not to be confused with
  ggplot2 themes) from which to derive the color palette. Available
  themes include: `"Atlas"`, `"Badge"`, `"Berlin"`, `"Celestial"`,
  `"Crop"`, `"Depth"`, `"Droplet"`, `"Facet"`, `"Feathered"`,
  `"Gallery"`, `"Headlines"`, `"Integral"`, `"Ion Boardroom"`, `"Ion"`,
  `"Madison"`, `"Main Event"`, `"Mesh"`, `"Office"`, `"Office 2013"`,
  `"Organic"`, `"Parallax"`, `"Parcel"`, `"Retrospect"`, `"Savon"`,
  `"Slice"`, `"Vapor Trail"`, `"View"`, `"Wisp"`, `"Wood Type"`,
  `"Aspect"`, `"Blue Green"`, `"Blue II"`, `"Blue Warm"`, `"Blue"`,
  `"Grayscale"`, `"Green Yellow"`, `"Green"`, `"Marquee"`, `"Median"`,
  `"Office 2007"`, `"Orange Red"`, `"Orange"`, `"Paper"`,
  `"Red Orange"`, `"Red Violet"`, `"Red"`, `"Slipstream"`,
  `"Violet II"`, `"Violet"`, `"Yellow Orange"`, `"Yellow"`

## Details

In 2023 Microsoft replaced the long-standing Office theme with a new
default and renamed the old one. The default here, `"Office"`, is the
current palette; `"Office 2013"` is the palette Excel used from 2013
until 2022. The former ggthemes names `"Office Theme"` and
`"Office 2007-2010"` still work, and select `"Office 2013"` and
`"Office 2007"` respectively.

## See also

Other colour excel:
[`excel_pal()`](https://jrnold.github.io/ggthemes/reference/excel_pal.md),
[`scale_colour_excel_new()`](https://jrnold.github.io/ggthemes/reference/scale_excel_new.md),
[`scale_fill_excel()`](https://jrnold.github.io/ggthemes/reference/scale_excel.md)

## Examples

``` r
library("scales")

for (i in names(ggthemes::ggthemes_data$excel$themes)) {
  show_col(excel_new_pal(theme = i)(6))
}


















































```
