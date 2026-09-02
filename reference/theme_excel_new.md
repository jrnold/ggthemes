# ggplot theme similar to current Excel plot defaults

Theme for ggplot2 that is similar to the default style of charts in
current versions of Microsoft Excel.

## Usage

``` r
theme_excel_new(base_size = 9, base_family = "sans")
```

## Arguments

- base_size:

  base font size, given in pts.

- base_family:

  base font family

## Value

An object of class
[`theme()`](https://ggplot2.tidyverse.org/reference/theme.html).

## Details

Excel derives its chart greys from the theme's `tx1` colour by luminance
transform rather than hardcoding them. Since `tx1` is black in every
built-in Office theme, these greys—`"#D9D9D9"` gridlines, `"#BFBFBF"`
axis lines, `"#595959"` text—are the same whichever theme
[`scale_colour_excel_new()`](https://jrnold.github.io/ggthemes/reference/scale_excel_new.md)
is set to.

Since 2023 the default font in Excel has been Aptos, but `base_family`
defaults to `"sans"` because Aptos is rarely installed outside of
Office. Pass `base_family = "Aptos Narrow"` for a closer match if you do
have it.

## See also

Other themes excel:
[`theme_excel()`](https://jrnold.github.io/ggthemes/reference/theme_excel.md)

## Examples

``` r
library("ggplot2")

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am)
p + theme_excel_new() + scale_colour_excel_new()
```
