library("ggplot2")

ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  theme_foundation()

# Extend the foundation to build a new theme
theme_minimal_box <- function(...) {
  theme_foundation(...) +
    theme(
      panel.grid = element_blank(),
      axis.ticks = element_line()
    )
}

ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  theme_minimal_box()
