library("ggplot2")

p <- ggplot(mtcars) + geom_point(aes(x = wt, y = mpg,
     colour = factor(gear))) +
     facet_wrap(~am) +
     # Economist puts scales on the right-hand side
     scale_y_continuous(position = "right")

## Standard
p + theme_economist() + scale_colour_economist()

## Stata colors
p + theme_economist(stata = TRUE) + scale_colour_economist(stata = TRUE)

## Darker plot region
p + theme_economist(dkpanel = TRUE) + scale_colour_economist(stata = TRUE)

# Change axis lines to vertical
p + theme_economist(horizontal = FALSE) +
    scale_colour_economist() +
    coord_flip()

## White panel/light gray background
p + theme_economist_white() +
    scale_colour_economist()

## All white variant
p + theme_economist_white(gray_bg = FALSE) +
    scale_colour_economist()

\dontrun{

## The Economist uses ITC Officina Sans
library(extrafont)
p + theme_economist(base_family="ITC Officina Sans") +
    scale_colour_economist()

## Verdana is a widely available substitute
p + theme_economist(base_family="Verdana") +
    scale_colour_economist()

}
