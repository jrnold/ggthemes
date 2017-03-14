### Name: circlefill_shape_pal
### Title: Filled Circle Shape palette (discrete)
### Aliases: circlefill_shape_pal

### ** Examples

library("ggplot2")
(ggplot(mtcars, aes(x=mpg, y=hp, shape=factor(cyl)))
 + geom_point() + scale_shape_tremmel())



