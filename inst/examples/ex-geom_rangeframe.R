library("ggplot2")

ggplot(mtcars, aes(wt, mpg)) +
 geom_point() +
 geom_rangeframe() +
 coord_cartesian(clip="off") +
 theme_tufte()

# In the example above,
# `coord_cartesian(clip="off")`` ensures that the full width of the line is drawn.
# if you know a better way to fix this,
# please open an issue or PR on github https://github.com/jrnold/ggthemes/issue
