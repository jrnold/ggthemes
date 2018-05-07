library("ggplot2")

df <- data.frame(
  x = runif(100),
  y = runif(100),
  z1 = rnorm(100),
  z2 = abs(rnorm(100))
)

p <- ggplot(df, aes(x, y)) +
     geom_point(aes(colour = z2)) +
     theme_igray()

p + scale_colour_gradient_tableau("Red")
p + scale_colour_gradient_tableau("Blue")
p + scale_colour_gradient_tableau("Green")
