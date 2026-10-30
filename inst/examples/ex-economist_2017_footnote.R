## The first eight, as the guide gives them
economist_2017_footnote(1:8)

## Beyond eight, the pattern continues
economist_2017_footnote(9)

## Mark the annotated text and start the footnote with the same symbol
library("ggplot2")
p <- ggplot(economics, aes(date, psavert)) +
  geom_line(colour = economist_2017_pal()(1)) +
  labs(
    title = "Saving grace",
    subtitle = paste0("United States, personal saving rate", economist_2017_footnote(1), ", %"),
    caption = "Source: US Bureau of Economic Analysis",
    x = NULL,
    y = NULL
  ) +
  theme_economist_2017(base_size = 7)
economist_2017_chart(
  p,
  footnote = paste0(economist_2017_footnote(1), "Seasonally adjusted"),
  number = 1
)
