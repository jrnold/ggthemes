### Name: theme_gdocs
### Title: Theme with Google Docs Chart defaults
### Aliases: theme_gdocs

### ** Examples

library("ggplot2")
p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am)
p + theme_gdocs() + scale_color_gdocs()



