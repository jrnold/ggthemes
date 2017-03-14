### Name: scale_colour_gradient2_tableau
### Title: Tableau diverging colour scales (continuous)
### Aliases: scale_colour_gradient2_tableau scale_fill_gradient2_tableau
###   scale_color_gradient2_tableau

### ** Examples

library("ggplot2")
df <- data.frame(
x = runif(100),
y = runif(100),
z1 = rnorm(100),
z2 = abs(rnorm(100))
)
p <- ggplot(df, aes(x, y)) + geom_point(aes(colour = z2))

p + scale_colour_gradient2_tableau()
p + scale_colour_gradient2_tableau('Orange-Blue')
p + scale_colour_gradient2_tableau('Temperature')



