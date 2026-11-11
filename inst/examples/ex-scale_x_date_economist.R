library("ggplot2")

# Daily data over most of a year: month initials, the year beneath.
days <- seq(as.Date("2016-01-01"), as.Date("2016-11-20"), by = "day")
banks <- data.frame(date = days, index = 100 + cumsum(sin(seq_along(days) / 9)))
p <- ggplot(banks, aes(date, index)) +
  geom_line(colour = "#00526d") +
  scale_x_date_economist(name = NULL) +
  scale_y_continuous(name = NULL, position = "right") +
  theme_economist(base_size = 6.5)
p

# Two years: each year centered under its span.
days <- seq(as.Date("2015-01-01"), as.Date("2016-11-20"), by = "day")
ringgit <- data.frame(date = days, index = 100 - seq_along(days) / 40 + sin(seq_along(days) / 20))
ggplot(ringgit, aes(date, index)) +
  geom_line(colour = "#00526d") +
  scale_x_date_economist(name = NULL) +
  scale_y_continuous(name = NULL, position = "right") +
  theme_economist(base_size = 6.5)

# Annual data over 16 years, on the ticks.
trade <- data.frame(date = as.Date(paste0(2000:2015, "-01-01")), value = (1:16)^2)
ggplot(trade, aes(date, value)) +
  geom_line(colour = "#00526d") +
  scale_x_date_economist(name = NULL, unit = "year", center = FALSE) +
  scale_y_continuous(name = NULL, position = "right") +
  theme_economist(base_size = 6.5)
