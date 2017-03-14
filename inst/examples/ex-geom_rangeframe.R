### Name: geom_rangeframe
### Title: Range Frames
### Aliases: geom_rangeframe GeomRangeFrame
### Keywords: datasets

### ** Examples

library("ggplot2")
ggplot(mtcars, aes(wt, mpg)) +
 geom_point() +
 geom_rangeframe() +
 theme_tufte()



