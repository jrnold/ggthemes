library("ggplot2")

wages <- data.frame(year = 2000:2020, index = seq(10, 48, length.out = 21))

# The gridline at 40 stops where the name stands on it.
gaps <- data.frame(y = 40, from = 2002, to = 2009)

ggplot(wages, aes(year, index)) +
  geom_gridline_economist_2024(seq(10, 50, 10), xmin = 2000, xmax = 2020, gaps = gaps) +
  geom_line(colour = economist_2024_pal()(1), linewidth = 0.8) +
  annotate("text", x = 2002, y = 40, label = "Real wages", hjust = 0) +
  scale_y_continuous(
    position = "right",
    limits = c(0, 51),
    breaks = seq(0, 50, 10),
    expand = c(0, 0)
  ) +
  scale_x_continuous(expand = c(0, 0)) +
  labs(title = "Pay check", subtitle = "Index, 2000=10", x = NULL, y = NULL) +
  theme_economist_2024() +
  theme(panel.grid.major.y = element_blank())
