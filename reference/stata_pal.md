# Stata color palettes (discrete)

Stata color palettes. See Stata documentation for a description of the
schemes, <https://www.stata.com/help.cgi?schemes>.

## Usage

``` r
stata_pal(scheme = "s2color")
```

## Arguments

- scheme:

  `character`. One of `"s2color"`, `"s1rcolor"`, `"s1color"`, or
  `"mono"`.

## Details

All these palettes support up to 15 values.

## Examples

``` r
library("scales")

show_col(stata_pal("s2color")(15))

show_col(stata_pal("s1rcolor")(15))

show_col(stata_pal("s1color")(15))

show_col(stata_pal("mono")(15))
```
