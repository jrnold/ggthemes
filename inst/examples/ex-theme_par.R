library("ggplot2")

p <- ggplot(mtcars) + geom_point(aes(x = wt, y = mpg,
     colour = factor(gear))) + facet_wrap(~am)
par(font = 2, col.lab = "red", fg = "blue")
p + theme_par()
