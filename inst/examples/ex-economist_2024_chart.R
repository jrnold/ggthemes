library("ggplot2")

p <- ggplot(economics, aes(date, psavert)) +
  geom_line(colour = economist_2024_pal("print")(1), linewidth = 1) +
  scale_y_continuous(position = "right", guide = guide_axis_economist_2017()) +
  labs(
    title = "Saving grace",
    subtitle = "United States, personal saving rate, %",
    x = NULL,
    y = NULL,
    caption = "Source: US Bureau of Economic Analysis"
  )

economist_2024_chart(p + theme_economist_2024("print"), "print", number = 1)
economist_2024_chart(
  p + theme_economist_2024("web"),
  "web",
  footnote = "*Seasonally adjusted"
)
