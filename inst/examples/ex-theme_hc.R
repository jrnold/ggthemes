### Name: theme_hc
### Title: Highcharts JS theme
### Aliases: theme_hc

### ** Examples

library("ggplot2")
p <- ggplot(mtcars) + geom_point(aes(x = wt, y = mpg,
     colour=factor(gear))) + facet_wrap(~am)
p + theme_hc() + scale_colour_hc()
p + theme_hc(bgcolor = 'darkunica') + scale_colour_hc('darkunica')



