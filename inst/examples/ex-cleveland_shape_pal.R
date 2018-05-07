###   (discrete).


library("ggplot2")
p <- ggplot(mtcars) +
     geom_point(aes(x = wt, y = mpg, shape = factor(gear))) +
     facet_wrap(~am) +
     theme_bw()
# overlapping symbol palette
p + scale_shape_cleveland()
# non-overlapping symbol palette
p + scale_shape_cleveland(overlap = FALSE)
