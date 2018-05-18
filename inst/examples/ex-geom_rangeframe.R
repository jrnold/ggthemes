library("ggplot2")

ggplot(mtcars, aes(wt, mpg)) +
 geom_point() +
 geom_rangeframe() +
 theme_tufte()
