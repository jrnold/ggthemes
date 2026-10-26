library("ggplot2")

# Two series, each with a band of uncertainty around it.
set.seed(1)
polls <- do.call(
  rbind,
  lapply(c("Conservative", "Liberal"), function(party) {
    x <- seq(2021, 2025, length.out = 60)
    trend <- if (party == "Liberal") 33 - 3 * (x - 2021) else 30 + 3 * (x - 2021)
    y <- trend + cumsum(rnorm(60, 0, 0.3))
    data.frame(party = party, x = x, y = y, lo = y - 4, hi = y + 4)
  })
)
colours <- c(Conservative = economist_2024_pal()(3)[3], Liberal = economist_2024_pal()(1))

ggplot(polls, aes(x, y, colour = party, fill = party, group = party)) +
  geom_ribbon_economist_2024(aes(ymin = lo, ymax = hi)) +
  geom_line(linewidth = 0.8) +
  scale_colour_manual(values = colours, guide = "none") +
  scale_fill_manual(values = colours, guide = "none") +
  scale_y_continuous(position = "right") +
  labs(title = "In poll position", subtitle = "Voting intention, %", x = NULL, y = NULL) +
  theme_economist_2024()
