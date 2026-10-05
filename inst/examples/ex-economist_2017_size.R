library("ggplot2")

## A one-column chart, 160pt wide, in inches
economist_2017_size("one_column", height = 165)

## Leader blocks have a fixed height
economist_2017_size("leader")
economist_2017_size("leader", units = "pt")

## Save a chart at the size the guide specifies
p <- ggplot(economics, aes(date, unemploy / 1000)) +
  geom_line(colour = economist_2017_pal()(1)) +
  labs(title = "Out of work", subtitle = "United States, unemployed, m", x = NULL, y = NULL) +
  theme_economist_2017()
size <- economist_2017_size("two_column", height = 200)
path <- tempfile(fileext = ".png")
ggsave(path, economist_2017_chart(p), width = size[["width"]], height = size[["height"]])
