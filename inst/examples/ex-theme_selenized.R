library(ggplot2)

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am)

# Use the same variant for the theme and the scale
p + theme_selenized() + scale_colour_selenized()
p + theme_selenized(variant = "dark") + scale_colour_selenized(variant = "dark")
p + theme_selenized(variant = "black") + scale_colour_selenized(variant = "black")
p + theme_selenized(variant = "white") + scale_colour_selenized(variant = "white")
