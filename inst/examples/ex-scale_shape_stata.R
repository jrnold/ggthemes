\dontrun{
library("ggplot2")

p <- ggplot(mtcars) +
     geom_point(aes(x = wt, y = mpg, shape = factor(gear))) +
     facet_wrap(~am)
p + theme_stata(scheme = "s2color") + scale_shape_stata()
}
