library("ggplot2")

# Use the classic sunspot data from Cleveland's original paper
x <- seq_along(sunspot.year)
y <- as.numeric(sunspot.year)
# Without banking
m <- ggplot(data.frame(x = x, y = y), aes(x = x, y = y)) +
  geom_line()
m

## Using the default method, Median Absolute Slope
ratio <- bank_slopes(x, y)
m + coord_fixed(ratio = ratio)

## Average Absolute Slope
m + coord_fixed(ratio = bank_slopes(x, y, method = "as"))

## Average Absolute Orientation
m + coord_fixed(ratio = bank_slopes(x, y, method = "ao"))

## Weighted Average Absolute Slope: each segment is weighted by its run in
## x, so this only differs from "as" when x is not evenly spaced
m + coord_fixed(ratio = bank_slopes(x, y, method = "was"))

## Culling removes slopes of 0 or Inf before banking, which matters when
## the data contains runs of repeated x or y values
bank_slopes(x, y, cull = TRUE)
