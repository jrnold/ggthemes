library("ggplot2")

p <- ggplot(mtcars) +
  geom_point(aes(
    x = wt,
    y = mpg,
    colour = factor(gear)
  )) +
  facet_wrap(~am)
p + theme_base()
# theme_base() is fixed; use theme_par() to follow the current par() values
old_par <- par(fg = "blue", bg = "gray", col.lab = "red", font.lab = 3)
p + theme_par()
par(old_par)
