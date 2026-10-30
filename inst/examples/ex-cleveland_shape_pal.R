library(ggplot2)

# Base pch symbols, which every font can draw: five for data where overlap
# causes problems, and two (a solid and an open circle) for little overlap.
ggplot(mtcars, aes(x = wt, y = mpg, shape = factor(gear))) +
  geom_point(size = 3) +
  scale_shape_cleveland(unicode = FALSE)

ggplot(mtcars, aes(x = wt, y = mpg, shape = factor(am))) +
  geom_point(size = 3) +
  scale_shape_cleveland(overlap = FALSE, unicode = FALSE)

# The default, unicode = TRUE, draws all five symbols of either set with the
# device font, which must cover them.
ggplot(mtcars, aes(x = wt, y = mpg, shape = factor(gear))) +
  geom_point(size = 3) +
  scale_shape_cleveland(overlap = FALSE)

# The symbols of the revised (second) edition
ggplot(mtcars, aes(x = wt, y = mpg, shape = factor(gear))) +
  geom_point(size = 3) +
  scale_shape_cleveland(edition = "1994")
