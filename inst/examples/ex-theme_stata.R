library("ggplot2")

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am) +
  labs(
    title = "Graphs by car type",
    x = "Weight (lbs.)",
    y = "MPG"
  )

# The st family, Stata's default since Stata 18
# stcolor
p + theme_stata(scheme = "stcolor") + scale_colour_stata("stcolor")
# stcolor_alt, which puts the legend below the plot
p + theme_stata(scheme = "stcolor_alt") + scale_colour_stata("stcolor")
# stmono1
p + theme_stata(scheme = "stmono1") + scale_colour_stata("mono")
# stmono2
p + theme_stata(scheme = "stmono2") + scale_colour_stata("mono")
# stsj, the Stata Journal scheme
p + theme_stata(scheme = "stsj") + scale_colour_stata("mono")

# The s1/s2 families, Stata's defaults through Stata 17
# s2color
p + theme_stata(scheme = "s2color") + scale_colour_stata("s2color")
# s2mono
p + theme_stata(scheme = "s2mono") + scale_colour_stata("mono")
# s1color
p + theme_stata(scheme = "s1color") + scale_colour_stata("s1color")
# s1rcolor
p + theme_stata(scheme = "s1rcolor") + scale_colour_stata("s1rcolor")
# s1mono
p + theme_stata(scheme = "s1mono") + scale_colour_stata("mono")
