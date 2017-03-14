### Name: colorblind_pal
### Title: Colorblind Color Palette (Discrete) and Scales
### Aliases: colorblind_pal scale_colour_colorblind scale_color_colorblind
###   scale_fill_colorblind

### ** Examples

library("ggplot2")
library(scales)
show_col(colorblind_pal()(8))
p <- ggplot(mtcars) + geom_point(aes(x = wt, y = mpg,
     colour=factor(gear))) + facet_wrap(~am)
p + theme_igray() + scale_colour_colorblind()



