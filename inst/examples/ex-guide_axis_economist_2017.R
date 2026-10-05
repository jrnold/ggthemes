library("ggplot2")

ggplot(economics, aes(date, unemploy / 1000)) +
  geom_line() +
  scale_y_continuous(position = "right", guide = guide_axis_economist_2017()) +
  labs(title = "Out of work", subtitle = "United States, unemployed, m", x = NULL, y = NULL) +
  theme_economist_2017()
