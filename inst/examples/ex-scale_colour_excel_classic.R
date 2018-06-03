library("ggplot2")

ggplot(mtcars, aes(x = wt, y = mpg, colour = factor(gear))) +
  geom_point() +
  ggtitle("Cars") +
  theme_excel_classic() +
  scale_colour_excel_classic()

ggplot(diamonds, aes(x = clarity, fill = cut)) +
  geom_bar() +
  scale_fill_excel_classic() +
  theme_excel_classic()
