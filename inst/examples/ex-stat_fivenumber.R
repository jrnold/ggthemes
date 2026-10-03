library("ggplot2")

ggplot(mtcars, aes(x = factor(cyl), y = mpg)) +
  stat_fivenumber()

# The whiskers can be set to other quantiles
ggplot(mtcars, aes(x = factor(cyl), y = mpg)) +
  stat_fivenumber(probs = c(0.05, 0.25, 0.5, 0.75, 0.95))
