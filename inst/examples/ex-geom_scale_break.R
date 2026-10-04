library("ggplot2")

# A y-axis truncated well above zero, declared with the styleguide's mark.
approval <- data.frame(
  year = 2005:2016,
  pct = c(62, 70, 68, 52, 44, 58, 70, 74, 71, 66, 44, 54)
)

ggplot(approval, aes(year, pct)) +
  geom_line(colour = economist_2017_pal(type = "line_side")(1)) +
  geom_scale_break() +
  scale_y_continuous(position = "right", guide = guide_axis_economist(), limits = c(30, 80)) +
  scale_x_continuous(labels = economist_year_format()) +
  labs(title = "Mutti's malaise", subtitle = "Approval, % polled", x = NULL, y = NULL) +
  theme_economist_2017()
