### Name: theme_economist
### Title: ggplot color theme based on the Economist
### Aliases: theme_economist theme_economist_white

### ** Examples

library("ggplot2")
p <- ggplot(mtcars) + geom_point(aes(x = wt, y = mpg,
     colour=factor(gear))) +
     facet_wrap(~am)

## Standard
p + theme_economist() + scale_colour_economist()

## Stata colors
p + theme_economist(stata=TRUE) + scale_colour_economist(stata=TRUE)

## Darker plot region
p + theme_economist(dkpanel=TRUE) + scale_colour_economist(stata=TRUE)

# Change axis lines to vertical
p + theme_economist(horizontal=FALSE) +
    scale_colour_economist() +
    coord_flip()

## White panel/light gray background
p + theme_economist_white() +
    scale_colour_economist()

## All white variant
p + theme_economist_white(gray_bg=FALSE) +
    scale_colour_economist()
## Not run: 
##D ## The Economist uses ITC Officina Sans
##D library(extrafont)
##D p + theme_economist(base_family="ITC Officina Sans") +
##D     scale_colour_economist()
##D 
##D ## Verdana is a widely available substitute
##D p + theme_economist(base_family="Verdana") +
##D     scale_colour_economist()
## End(Not run)



