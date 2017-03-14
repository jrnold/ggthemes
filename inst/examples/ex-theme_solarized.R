### Name: theme_solarized
### Title: ggplot color themes based on the Solarized palette
### Aliases: theme_solarized theme_solarized_2

### ** Examples

library("ggplot2")
p <- ggplot(mtcars) +
     geom_point(aes(x = wt, y = mpg, colour=factor(gear))) +
     facet_wrap(~am)
p + theme_solarized() + scale_colour_solarized('blue')

## Dark version
p + theme_solarized(light = FALSE) +
    scale_colour_solarized('blue')



