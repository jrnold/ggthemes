library("ggplot2")

ggplot(mtcars, aes(x = wt, y = mpg, colour = factor(gear))) +
  geom_point() +
  ggtitle("Cars") +
  theme_excel_new() +
  scale_colour_excel_new()
