### Name: scale_shape_stata
### Title: Stata shape scale
### Aliases: scale_shape_stata

### ** Examples

library("ggplot2")
p <- ggplot(mtcars) +
     geom_point(aes(x = wt, y = mpg, shape = factor(gear))) +
     facet_wrap(~am)
p + theme_stata() + scale_shape_stata()



