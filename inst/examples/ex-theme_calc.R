library("ggplot2")

p <- ggplot(mtcars) +
     geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
     facet_wrap(~am) + theme_calc()
p + scale_color_calc()
q <- ggplot(mtcars) +
     geom_point(aes(x = wt, y = mpg, shape = factor(gear))) +
     facet_wrap(~am) +
     theme_calc()
q + scale_shape_calc()
