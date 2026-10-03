library("ggplot2")

# Continuous scale
ggplot(mtcars, aes(x = wt, y = mpg, colour = disp)) +
  geom_point(size = 3) +
  scale_colour_economist_c(hue = "blue")

# Ordinal (discrete) scale for an ordered factor
ggplot(mtcars, aes(x = wt, y = mpg, colour = factor(cyl, ordered = TRUE))) +
  geom_point(size = 3) +
  scale_colour_economist_ordinal(hue = "red")
