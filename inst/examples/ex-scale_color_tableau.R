library("ggplot2")

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am) +
  theme_igray()

palettes <- GGTHEMES[["tableau"]][["color-palettes"]][["regular"]]
for (palette in names(palettes)) {
  print(p + scale_colour_tableau(palette) +
          ggtitle(palette))
}
