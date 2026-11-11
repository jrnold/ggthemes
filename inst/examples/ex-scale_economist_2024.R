library("ggplot2")

p <- ggplot(mpg, aes(displ, hwy, colour = drv)) +
  geom_point()
p + scale_colour_economist_2024("web") + theme_economist_2024("web")

ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_raster() +
  scale_fill_gradient_economist_2024("red", "web") +
  theme_economist_2024("web")

# A diverging ramp, neutral at `midpoint`; direction = -1 puts gray on top
df <- expand.grid(x = 1:10, y = 1:10)
df$z <- df$x - df$y + 3
ggplot(df, aes(x, y, fill = z)) +
  geom_tile() +
  scale_fill_gradient2_economist_2024("web", direction = -1, midpoint = 3) +
  theme_economist_2024("web")
