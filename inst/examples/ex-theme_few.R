library("ggplot2")

p <- ggplot(mtcars) + geom_point(aes(x = wt, y = mpg,
    colour = factor(gear))) + facet_wrap(~am)
p + theme_few() + scale_colour_few()
p + theme_few() + scale_colour_few("light")
p + theme_few() + scale_colour_few("dark")
