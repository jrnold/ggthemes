library("ggplot2")
library("scales")

show_col(colorblind_pal()(8))
p <- ggplot(mtcars) + geom_point(aes(x = wt, y = mpg,
     colour = factor(gear))) + facet_wrap(~am)
p + theme_igray() + scale_colour_colorblind()
