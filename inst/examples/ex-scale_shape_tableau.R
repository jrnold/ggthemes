library("ggplot2")

p <- ggplot(mtcars) +
     geom_point(aes(x = wt, y = mpg, shape = factor(gear))) +
     facet_wrap(~am)
p + scale_shape_tableau()
