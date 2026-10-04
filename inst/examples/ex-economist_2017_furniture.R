library("ggplot2")

p <- ggplot(economics, aes(date, psavert)) +
  geom_line(colour = economist_2017_pal("web")(2)[2]) +
  scale_y_continuous(position = "right", guide = guide_axis_economist()) +
  labs(
    title = "Saving grace",
    subtitle = "United States, personal saving rate, %",
    x = NULL,
    y = NULL,
    caption = "Source: US Bureau of Economic Analysis"
  )

economist_2017_furniture(p + theme_economist_2017("web"), "web")

## Panel charts get a red marker above each heading
economist_2017_furniture(
  ggplot(mpg, aes(displ, hwy)) +
    geom_point(colour = economist_2017_pal()(1)) +
    facet_wrap(~year) +
    scale_y_continuous(position = "right", guide = guide_axis_economist()) +
    labs(title = "Thirst quenched", subtitle = "Highway miles per gallon v engine size") +
    theme_economist_2017()
)
