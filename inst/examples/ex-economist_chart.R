library("ggplot2")

p <- ggplot(economics, aes(date, psavert)) +
  geom_line(colour = economist_pal()(1)) +
  scale_y_continuous(position = "right") +
  labs(
    title = "Saving grace",
    subtitle = "United States, personal saving rate, %",
    x = NULL,
    y = NULL,
    caption = "Source: US Bureau of Economic Analysis"
  ) +
  theme_economist(base_size = 6.5)

economist_chart(p)

## A chart the text refers to as chart 2
economist_chart(p, number = 2)

## A value axis that does not start at zero, marked as broken
economist_chart(p + scale_y_continuous(position = "right", limits = c(2, 18)), scale_break = "right")
