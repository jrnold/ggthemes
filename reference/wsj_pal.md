# Wall Street Journal color palette (discrete)

The Wall Street Journal uses many different color palettes in its plots.
This collects a few of them, but is by no means exhaustive. Collections
of these plots can be found on the WSJ Graphics [X (formerly
Twitter)](https://x.com/WSJGraphics) feed and
[Pinterest](https://pinterest.com/wsjgraphics/wsj-graphics/).

## Usage

``` r
wsj_pal(palette = "colors6")
```

## Arguments

- palette:

  `character` The color palette to use: . `"rgby"`, `"red_green"`,
  `"black_green"`, `"dem_rep"`, `"colors6"`

## Palettes

The following palettes are defined,

- rgby:

  Red/Green/Blue/Yellow theme.

- red_green:

  Green/red two-color scale for good/bad.

- green_black:

  Black-green 4-color scale for 'Very negative', 'Somewhat negative',
  'somewhat positive', 'very positive'.

- dem_rep:

  Democrat/Republican/Undecided blue/red/gray scale.

- colors6:

  Red, blue, gold, green, orange, and black palette.

## See also

Other colour wsj:
[`scale_colour_wsj()`](https://jrnold.github.io/ggthemes/reference/scale_wsj.md)
