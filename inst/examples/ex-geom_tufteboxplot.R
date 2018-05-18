library("ggplot2")

p <- ggplot(mtcars, aes(factor(cyl), mpg))
## with a point for the median and lines for whiskers
p + geom_tufteboxplot()
## with a line for the interquartile range and points for whiskers
p + geom_tufteboxplot(median.type = "line", whisker.type = "point", hoffset = 0)
## with a wide line for the interquartile range and lines for whiskers
p + geom_tufteboxplot(median.type = "line", hoffset = 0, width = 3)
## with an offset line for the interquartile range and lines for whiskers
p + geom_tufteboxplot(median.type = "line")
