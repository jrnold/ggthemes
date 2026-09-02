library("ggplot2")

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am) +
  theme_numbers()

for (palette in head(names(ggthemes_data[["numbers"]]), 3L)) {
  print(p + scale_colour_numbers(palette) + ggtitle(palette))
}
