library("ggplot2")

# Old line color
p <- ggplot(mtcars) +
     geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
     facet_wrap(~am)
p + theme_excel() + scale_colour_excel()

# Old fill color palette
ggplot(mpg, aes(x = class, fill = drv)) +
  geom_bar() +
  scale_fill_excel("fill") +
  theme_excel()
