library("ggplot2")

(ggplot(mtcars, aes(x = mpg, y = hp, shape = factor(cyl)))
 + geom_point() + scale_shape_tremmel())
