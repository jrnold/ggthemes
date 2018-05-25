library("ggplot2")

ggplot(mtcars, aes(wt, mpg)) +
 geom_point() +
 theme_solid(fill = "white")

ggplot(mtcars, aes(wt, mpg)) +
  geom_point(color = "white") +
  theme_solid(fill = "black")
