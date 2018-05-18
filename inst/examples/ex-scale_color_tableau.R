library("ggplot2")

p <- ggplot(mtcars) +
     geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
     facet_wrap(~am)
p + scale_colour_tableau()
p + scale_colour_tableau("tableau20")
p + scale_colour_tableau("tableau10medium")
p + scale_colour_tableau("tableau10light")
p + scale_colour_tableau("colorblind10")
p + scale_colour_tableau("trafficlight")
p + scale_colour_tableau("purplegray12")
p + scale_colour_tableau("bluered12")
p + scale_colour_tableau("greenorange12")
p + scale_colour_tableau("cyclic")
