library("ggplot2")

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am) +
  labs(
    title = "Heavy Going",
    subtitle = "Miles per gallon by weight, 1974 Motor Trend road tests",
    colour = "Gears",
    caption = "Source: Motor Trend"
  )
p + scale_colour_wsj("categorical") + theme_wsj()
# The pale gray field used from August 2013
p + scale_colour_wsj("categorical") + theme_wsj(paper = "gray")
# Unit symbol on the topmost break only, as WSJ axes print it
p +
  scale_colour_wsj("categorical") +
  scale_y_continuous(labels = wsj_label(suffix = " mpg")) +
  theme_wsj()
# The charts of 2011 and 2012: a bold subtitle, and bands in place of the rules
p$layers <- c(wsj_bands(), p$layers)
p +
  scale_colour_wsj("categorical") +
  theme_wsj(subtitle_face = "bold", rules = "none")
# Before the October 2011 redesign: a pale blue field and the bright colors
p +
  scale_colour_wsj("bright") +
  theme_wsj(paper = "pale_blue", title_family = "sans", subtitle_face = "bold")
