### Name: theme_igray
### Title: Inverse gray theme
### Aliases: theme_igray

### ** Examples

library("ggplot2")
p <- ggplot(mtcars) +
    geom_point(aes(x = wt, y = mpg, colour=factor(gear))) +
    facet_wrap(~am)
p + theme_igray()



