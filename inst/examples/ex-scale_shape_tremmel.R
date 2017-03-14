### Name: scale_shape_tremmel
### Title: Shape scales from Tremmel (1995)
### Aliases: scale_shape_tremmel

### ** Examples

library("ggplot2")
(ggplot(mtcars, aes(x=mpg, y=hp, shape=factor(cyl)))
 + geom_point() + scale_shape_tremmel())
(ggplot(mtcars, aes(x=mpg, y=hp, shape=factor(cyl)))
 + geom_point() + scale_shape_tremmel(n3alt=FALSE))
(ggplot(mtcars, aes(x=mpg, y=hp, shape=factor(am)))
 + geom_point() + scale_shape_tremmel())
(ggplot(mtcars, aes(x=mpg, y=hp, shape=factor(am)))
 + geom_point() + scale_shape_tremmel(overlap=TRUE))



