library("ggplot2")

ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  geom_rangeframe() +
  coord_cartesian(clip = "off") +
  theme_tufte()

# In the example above,
# `coord_cartesian(clip="off")`` ensures that the full width of the line is drawn.
# if you know a better way to fix this,
# please open an issue or PR on github https://github.com/jrnold/ggthemes/issue

# sides = "trbl" also works with a secondary axis: the secondary axis only
# relabels the existing scale, so the frame is still correctly positioned.
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  geom_rangeframe(sides = "trbl") +
  scale_y_continuous(sec.axis = sec_axis(~ . * 0.4251, name = "km/L")) +
  coord_cartesian(clip = "off") +
  theme_tufte()
