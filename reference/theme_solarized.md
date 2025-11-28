# ggplot color themes based on the Solarized palette

See <https://ethanschoonover.com/solarized/> for a description of the
Solarized palette.

## Usage

``` r
theme_solarized(base_size = 12, base_family = "", light = TRUE)

theme_solarized_2(base_size = 12, base_family = "", light = TRUE)
```

## Arguments

- base_size:

  base font size, given in pts.

- base_family:

  base font family

- light:

  `logical`. Light or dark theme?

## Details

Plots made with this theme integrate seamlessly with the Solarized
Beamer color theme.
<https://github.com/jrnold/beamercolorthemesolarized>. There are two
variations: `theme_solarized` is similar to to
[`theme_bw()`](https://ggplot2.tidyverse.org/reference/ggtheme.html),
while `theme_solarized_2()` is similar to
[`theme_gray()`](https://ggplot2.tidyverse.org/reference/ggtheme.html).

## Examples

``` r
library("ggplot2")

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear)))

# Light version with different main accent colors
for (accent in names(ggthemes::ggthemes_data[["solarized"]][["accents"]])) {
  print(p + theme_solarized() +
    scale_colour_solarized(accent))
}

# Dark version
p + theme_solarized(light = FALSE) +
  scale_colour_solarized("blue")


# Alternative theme
p + theme_solarized_2(light = FALSE) +
  scale_colour_solarized("blue")
```
