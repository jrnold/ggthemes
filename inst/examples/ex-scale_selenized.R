library("ggplot2")

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am)
p + theme_selenized() + scale_colour_selenized()
p + theme_selenized(variant = "dark") + scale_colour_selenized(accent = "orange", variant = "dark")
