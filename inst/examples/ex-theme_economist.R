library("ggplot2")

p <- ggplot(mtcars) +
     geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
     facet_wrap(~am) +
     # The Economist puts the y-axis labels on the right-hand side
     scale_y_continuous(position = "right") +
     labs(
       title = "Heavier, thirstier",
       subtitle = "Fuel economy v weight, by number of forward gears",
       caption = "Source: Motor Trend, 1974"
     )

## Standard
p + theme_economist() +
  scale_colour_economist()

# Vertical gridlines, for use with coord_flip()
p + theme_economist(horizontal = FALSE) +
    scale_colour_economist() +
    coord_flip()

## Ordered data uses one hue's equal-lightness steps instead
ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = hp)) +
  scale_colour_economist_c(hue = "blue") +
  theme_economist()

\dontrun{

## The Economist sets charts in "Econ Sans", which is not publicly
## available. Any narrow humanist sans is a reasonable substitute.
library("extrafont")
p + theme_economist(base_family = "Roboto Condensed") +
    scale_colour_economist()

}
