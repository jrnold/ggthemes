library("ggplot2")

ggplot(mtcars, aes(x = wt, y = mpg, colour = factor(gear))) +
  geom_point() +
  ggtitle("Cars") +
  theme_excel() +
  scale_colour_excel()

ggplot(diamonds, aes(x = clarity, fill = cut)) +
  geom_bar() +
  scale_fill_excel() +
  theme_excel()
