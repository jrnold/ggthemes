library("ggplot2")

p <- ggplot(mpg, aes(displ, hwy, colour = drv)) +
  geom_point() +
  scale_y_continuous(position = "right", guide = guide_axis_economist()) +
  labs(x = NULL, y = NULL)

p + scale_colour_economist_2017(type = "dot") + theme_economist_2017()
p + scale_colour_economist_2017("web") + theme_economist_2017("web")

## Continuous data uses one hue's equal-lightness ramp
ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_raster() +
  scale_fill_economist_2017_c(hue = "cyan") +
  theme_economist_2017("web")
