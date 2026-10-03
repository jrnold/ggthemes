# Pretty breaks that always include the extremes of the data
extended_range_breaks_(min(mtcars$wt), max(mtcars$wt))

# A function, in the style of the scales package
extended_range_breaks()(mtcars$wt)

library("ggplot2")

ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  geom_rangeframe() +
  scale_x_continuous(breaks = extended_range_breaks()(mtcars$wt)) +
  scale_y_continuous(breaks = extended_range_breaks()(mtcars$mpg)) +
  theme_tufte()
