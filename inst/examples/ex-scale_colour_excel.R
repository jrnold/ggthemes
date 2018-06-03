library("ggplot2")

ggplot(mtcars, aes(x = wt, y = mpg, colour = factor(gear))) +
  geom_point() +
  ggtitle("Cars") +
  theme_bw() +
  scale_colour_excel()
