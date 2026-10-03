smart_digits(c(0.1234, 0.5, 1.25))

smart_digits(c(1234.5678, 2000, 10000))

# A labelling function for use in a scale
library("ggplot2")

ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  scale_y_continuous(labels = smart_digits_format())
