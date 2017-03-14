### Name: scale_fill_solarized
### Title: Solarized color scales
### Aliases: scale_fill_solarized scale_colour_solarized
###   scale_color_solarized

### ** Examples

library("ggplot2")
p <- ggplot(mtcars) +
     geom_point(aes(x = wt, y = mpg, colour=factor(gear))) +
     facet_wrap(~am)
p + theme_solarized() + scale_colour_solarized()



