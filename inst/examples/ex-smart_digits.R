# Use scales::label_number() instead
scales::label_number()(c(0.1234, 0.5, 1.25))

library(ggplot2)

ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  scale_y_continuous(labels = scales::label_number())
