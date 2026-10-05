library("ggplot2")

p <- ggplot(economics, aes(date, unemploy / 1000)) +
  geom_line() +
  theme_economist_2017()

## A one-line callout pointing down at a point on the line
p + annotate("label_economist_2017", x = as.Date("2009-10-01"), y = 15.4, label = "Unemployment peaks")

## Two lines, pointing left, with the pointer off-centre
p +
  annotate("label_economist_2017",
    x = as.Date("1983-01-01"), y = 12, label = "Volcker\nrecession",
    pointer = "left", vjust = 0.25
  )

## The guide multiplies the box color over the print background
ground <- ggthemes_data$economist_2017$print$ground
box <- ggthemes_data$economist_2017$print$number_box
multiply <- grDevices::rgb(
  t(grDevices::col2rgb(box) * grDevices::col2rgb(ground) / 255),
  maxColorValue = 255
)
p +
  annotate(
    "label_economist_2017",
    x = as.Date("2009-10-01"), y = 15.4, label = "Unemployment peaks", fill = multiply
  )
