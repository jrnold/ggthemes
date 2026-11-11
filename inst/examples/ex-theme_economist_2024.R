library("ggplot2")

p <- ggplot(economics, aes(date, psavert)) +
  geom_line(colour = economist_2024_pal("print")(1), linewidth = 1) +
  scale_y_continuous(position = "right") +
  labs(
    title = "Saving grace",
    subtitle = "United States, personal saving rate, %",
    x = NULL,
    y = NULL,
    caption = "Source: US Bureau of Economic Analysis"
  )
p + theme_economist_2024("print")
p + theme_economist_2024("web")

ggplot(mpg, aes(hwy, class)) +
  geom_boxplot() +
  theme_economist_2024("web", horizontal = FALSE)
