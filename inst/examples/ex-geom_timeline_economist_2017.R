library("ggplot2")

oil <- data.frame(
  year = 1965:2015,
  production = c(
    1.9, 2.1, 2.6, 2.8, 3.4, 3.8, 4.6, 5.1, 5.9, 6.1, 5.4, 5.9, 5.7, 5.3, 3.2, 1.5, 1.3,
    2.4, 2.4, 2.0, 2.2, 2.0, 2.3, 2.3, 2.9, 3.3, 3.5, 3.5, 3.7, 3.7, 3.7, 3.8, 3.8, 3.9,
    3.6, 3.8, 3.8, 3.6, 4.0, 4.2, 4.2, 4.3, 4.3, 4.4, 4.2, 4.3, 4.3, 3.8, 3.6, 3.7, 3.6
  )
)
events <- data.frame(
  year = c(1968.8, 1979.9, 1988.5, 2001.6, 2014.6),
  label = c(
    "Iran signs\nNon-proliferation\nTreaty", "Iranian revolution.\nShah overthrown",
    "USS Vincennes shoots\ndown Iranian civil airliner", "US invades Afghanistan",
    "IS takes\nMosul"
  ),
  top = c(4.1, 7.1, 1.3, 4.1, 1.8),
  hjust = c(0.5, 0, 0, 1, 0.5)
)
leaders <- data.frame(
  start = c(1965, 1979.9, 1989.9),
  end = c(1979.7, 1989.8, 2016.5),
  leader = c("Reza Shah Pahlavi", "Ruhollah Khomeini", "Ali Khamenei")
)

ggplot(oil, aes(year, production)) +
  geom_span_economist_2017(
    aes(xmin = 1980.7, xmax = 1989, ymin = 0, ymax = 4.06, label = "Iran/Iraq war"),
    data = data.frame(), inherit.aes = FALSE
  ) +
  geom_line(colour = "#3DBCD2", linewidth = 0.8) +
  geom_event_economist_2017(
    aes(x = year, y = 0, yend = top, label = label, hjust = hjust),
    data = events, inherit.aes = FALSE
  ) +
  geom_year_band_economist_2017(from = 1965, to = 2016, y = 0) +
  geom_period_economist_2017(
    aes(xmin = start, xmax = end, y = -1.6, label = leader),
    data = leaders, inherit.aes = FALSE,
    fills = c("#748D99", "#00919E", "#7EC9C7")
  ) +
  scale_y_continuous(limits = c(-2.6, 7.6), breaks = seq(0, 6, 2), expand = c(0, 0)) +
  coord_cartesian(clip = "off") +
  labs(
    title = "More than an oil giant", subtitle = "Iran, oil production, m bpd",
    x = NULL, y = NULL
  ) +
  theme_economist_2017() +
  theme(
    axis.text.x = element_blank(), axis.ticks.x = element_blank(),
    axis.line.x = element_blank()
  )
