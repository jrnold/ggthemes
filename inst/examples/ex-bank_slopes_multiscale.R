library("ggplot2")

# Sunspot activity, the classic example from Cleveland and from Heer and
# Agrawala's Section 3.2.1. Spectral analysis identifies scales at frequency
# indices 7, 10, 31 and 36, plus the data in its entirety; culling similar
# aspect ratios leaves two charts worth drawing.
y <- as.numeric(sunspot.year)
bank_slopes_multiscale(y)

# `ratio` is ready for coord_fixed(); `aspect_ratio` is the same value as
# width / height, the convention used in the banking literature.
scales <- bank_slopes_multiscale(y)

m <- ggplot(data.frame(x = seq_along(y), y = y), aes(x = x, y = y)) +
  geom_line()

## The low-frequency trend: the oscillation of high points across cycles
m + coord_fixed(ratio = scales$ratio[[1]])

## The 11-year cycle: a steep onset followed by a more gradual decay
m + coord_fixed(ratio = scales$ratio[[2]])

## Raise the threshold to select fewer scales
bank_slopes_multiscale(y, threshold = Inf)

## Any of the single-scale banking methods can be used for each scale
bank_slopes_multiscale(y, method = "ao")
