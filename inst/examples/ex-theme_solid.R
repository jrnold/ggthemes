### Name: theme_solid
### Title: Theme with nothing other than a background color
### Aliases: theme_solid

### ** Examples

library("ggplot2")
(ggplot(mtcars, aes(wt, mpg))
 + geom_point()
 + theme_solid(fill = "white"))



