library("ggplot2")

p <- ggplot(mtcars) + geom_point(aes(x = wt, y = mpg,
     colour = factor(gear))) + facet_wrap(~am)
p + theme_base()
# Change values of par
par(fg = "blue", bg = "gray", col.lab = "red", font.lab = 3)
p + theme_base()
