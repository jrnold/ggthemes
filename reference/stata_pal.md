# Stata color palettes (discrete)

Stata color palettes. See Stata documentation for a description of the
schemes, <https://www.stata.com/help.cgi?schemes>.

## Usage

``` r
stata_pal(scheme = NULL)
```

## Arguments

- scheme:

  `character`. One of `"s2color"`, `"s1rcolor"`, `"s1color"`, `"mono"`,
  `"stcolor"`, or `"economist"`. If `NULL`, the default, `"s2color"` is
  used and a deprecation message is issued; this default becomes
  `"stcolor"` in ggthemes 7.0.0.

## Details

All these palettes support up to 15 values.

Stata's palettes come in two generations, and both are included here.

- Stata 17 and earlier:

  Schemes `"s2color"`, `"s1color"`, `"s1rcolor"`, and `"mono"` are built
  from Stata's classic named colors (`navy`, `maroon`, `forest_green`,
  and so on) and the `gs0`–`gs16` gray scale. `"s2color"` was Stata's
  factory default through Stata 17.

- Stata 18 and later:

  Scheme `"stcolor"` uses the `stc1`–`stc15` colors introduced in
  Stata 18. They are brighter than the classic palette and chosen to
  stay distinguishable for readers with a color vision deficiency. The
  first four are also available under the aliases `stblue`, `stred`,
  `stgreen`, and `styellow`. `"stcolor"` has been Stata's factory
  default since Stata 18.

`"economist"` is not one of Stata's general-purpose schemes; it is the
set of Economist-styled colors that Stata ships in
`scheme-economist.scheme`.

## See also

Other colour stata:
[`scale_colour_stata()`](https://jrnold.github.io/ggthemes/reference/scale_stata.md)

## Examples

``` r
library("scales")

# Stata 18 and later (the current factory default)
show_col(stata_pal("stcolor")(15))


# Stata 17 and earlier
show_col(stata_pal("s2color")(15))

show_col(stata_pal("s1rcolor")(15))

show_col(stata_pal("s1color")(15))

show_col(stata_pal("mono")(15))
```
