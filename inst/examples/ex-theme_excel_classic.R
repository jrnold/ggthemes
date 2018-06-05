library("ggplot2")

# Line and scatter plot colors
p <- ggplot(mtcars) +
     geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
     facet_wrap(~am)
p + theme_excel_classic() + scale_colour_excel_classic()

# Bar plot (area/fill) colors
ggplot(mpg, aes(x = class, fill = drv)) +
  geom_bar() +
  scale_fill_excel_classic() +
  theme_excel_classic()
