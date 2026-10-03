library("ggplot2")

ggplot(mtcars, aes(x = wt, y = mpg, colour = factor(gear))) +
  geom_point(size = 3) +
  scale_colour_hc(palette = "darkunica")
