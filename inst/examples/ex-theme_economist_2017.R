library("ggplot2")

yields <- data.frame(
  year = rep(1:13, 2),
  country = rep(c("January 1989 (Japan)", "January 1999 (US)"), each = 13),
  yield = c(
    5.3, 6.9, 5.5, 4.6, 4.0, 3.3, 2.8, 1.9, 1.7, 1.4, 1.6, 1.3, 1.5,
    5.6, 6.2, 5.0, 4.6, 4.3, 4.3, 4.8, 4.6, 3.7, 3.3, 3.2, 3.4, 2.3
  )
)

p <- ggplot(yields, aes(year, yield, colour = country)) +
  geom_line() +
  scale_x_continuous(breaks = c(1, 5, 10, 13)) +
  scale_y_continuous(position = "right", guide = guide_axis_economist(), limits = c(0, 8)) +
  labs(
    title = "Where Tokyo leads",
    subtitle = "Ten-year government-bond yields, %",
    colour = "Period beginning:",
    x = "Years since start",
    y = NULL,
    caption = "Source: Thomson Reuters"
  )

## Print
p + scale_colour_economist_2017(type = "line_side") + theme_economist_2017()

## Web
p + scale_colour_economist_2017("web") + theme_economist_2017("web")

## Vertical gridlines, for a horizontal bar chart
ggplot(mpg, aes(hwy, class)) +
  geom_boxplot() +
  theme_economist_2017(horizontal = FALSE)

## The guide's sizes suit its own chart widths. On a larger figure, scale
## everything up with base_size.
p + scale_colour_economist_2017(type = "line_side") + theme_economist_2017(base_size = 14)
