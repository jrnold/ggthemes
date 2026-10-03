library("ggplot2")

ggplot(mtcars, aes(x = wt, y = mpg, shape = factor(gear))) +
  geom_point(size = 3) +
  scale_shape_cleveland()
