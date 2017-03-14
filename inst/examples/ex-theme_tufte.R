### Name: theme_tufte
### Title: Tufte Maximal Data, Minimal Ink Theme
### Aliases: theme_tufte

### ** Examples

library("ggplot2")
# with ticks and range frames
(ggplot(mtcars, aes(wt, mpg))
 + geom_point() + geom_rangeframe()
 + theme_tufte())
# with geom_rug
(ggplot(mtcars, aes(wt, mpg))
 + geom_point() + geom_rug()
 + theme_tufte(ticks=FALSE))
## Not run: 
##D ## Using the Bembo serif family
##D library(extrafont)
##D (ggplot(mtcars, aes(wt, mpg))
##D  + geom_point() + geom_rangeframe()
##D  + theme_tufte(base_family='BemboStd'))
##D ## Using the Gill Sans sans serif family
##D (ggplot(mtcars, aes(wt, mpg))
##D  + geom_point() + geom_rangeframe()
##D  + theme_tufte(base_family='GillSans'))
## End(Not run)



