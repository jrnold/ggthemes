test_that("power_spectrum peaks at the frequency present in the signal", {
  n <- 64
  # A pure sinusoid completing 3 cycles across the series.
  y <- sin(2 * pi * 3 * seq_len(n) / n)
  expect_equal(which.max(power_spectrum(y)), 3L)
})

test_that("power_spectrum returns only the non-redundant half of the spectrum", {
  n <- 64
  y <- sin(2 * pi * 3 * seq_len(n) / n)
  expect_equal(length(power_spectrum(y)), n %/% 2)
})

test_that("power_spectrum drops the DC term so a constant offset does not change it", {
  n <- 64
  y <- sin(2 * pi * 3 * seq_len(n) / n)
  # |sum(y)|^2 would otherwise dominate every other bin and wreck the
  # mean-of-spectrum threshold.
  expect_equal(power_spectrum(y + 1000), power_spectrum(y))
})

test_that("lowpass keeps components at or below the cutoff and removes those above", {
  n <- 128
  i <- seq_len(n)
  slow <- sin(2 * pi * 3 * i / n)
  fast <- 0.5 * sin(2 * pi * 20 * i / n)
  expect_equal(lowpass(slow + fast, 3), slow, tolerance = 1e-8)
})

test_that("lowpass at the Nyquist cutoff returns the signal unchanged", {
  n <- 128
  i <- seq_len(n)
  y <- sin(2 * pi * 3 * i / n) + 0.5 * sin(2 * pi * 20 * i / n)
  expect_equal(lowpass(y, n %/% 2), y, tolerance = 1e-8)
})

test_that("lowpass preserves the series mean, since DC is not a high frequency", {
  n <- 128
  y <- sin(2 * pi * 3 * seq_len(n) / n) + 1000
  expect_equal(mean(lowpass(y, 3)), 1000, tolerance = 1e-8)
})

test_that("lowpass returns a real vector, not a complex one", {
  y <- sin(2 * pi * 3 * seq_len(64) / 64)
  expect_type(lowpass(y, 3), "double")
})

test_that("smooth_spectrum leaves a constant series untouched, including at the edges", {
  # Renormalizing the kernel over in-range taps only. A zero-padded
  # convolution would droop at the first and last elements, biasing them
  # below the threshold.
  p <- rep(5, 10)
  expect_equal(smooth_spectrum(p, window = 3, sd = 1), p)
})

test_that("smooth_spectrum preserves length", {
  p <- c(1, 8, 2, 9, 3)
  expect_equal(length(smooth_spectrum(p, window = 3, sd = 1)), 5L)
})

test_that("smooth_spectrum spreads an isolated spike into its neighbours", {
  p <- c(0, 0, 10, 0, 0)
  out <- smooth_spectrum(p, window = 3, sd = 1)
  expect_lt(out[3], 10)
  expect_gt(out[2], 0)
  expect_gt(out[4], 0)
})

test_that("smooth_spectrum with a window of 1 is a no-op", {
  p <- c(1, 8, 2, 9, 3)
  expect_equal(smooth_spectrum(p, window = 1, sd = 1), p)
})

test_that("select_scales keeps only the last index of each above-threshold run", {
  # Runs above 3: indices 2-3 and index 6. Index 7 is always included as the
  # scale of the data in its entirety.
  z <- c(1, 5, 6, 1, 1, 7, 1)
  expect_equal(select_scales(z, threshold = 3), c(3L, 6L, 7L))
})

test_that("select_scales always includes the final index, even if below threshold", {
  z <- c(9, 1, 1)
  expect_equal(select_scales(z, threshold = 3), c(1L, 3L))
})

test_that("select_scales does not duplicate a run that ends at the final index", {
  z <- c(1, 1, 9)
  expect_equal(select_scales(z, threshold = 3), 3L)
})

test_that("select_scales returns the entire-data scale when nothing exceeds the threshold", {
  z <- c(1, 1, 1, 1)
  expect_equal(select_scales(z, threshold = 100), 4L)
})

test_that("cull_ratios always keeps the first ratio", {
  expect_equal(cull_ratios(c(4.23), scale_factor = 1.25), 4.23)
})

test_that("cull_ratios drops a ratio too close to the one before it", {
  # 4.2 / 4 = 1.05, below the 1.25 threshold, so it would produce a chart
  # nearly identical to the first. 20 / 4 = 5 is clearly distinct.
  expect_equal(cull_ratios(c(4, 4.2, 20), scale_factor = 1.25), c(4, 20))
})

test_that("cull_ratios keeps both scales in the paper's PRMTX case", {
  # Section 3.2.3: one scale of interest plus the entirety of the data,
  # reported as two charts at aspect ratios 4.23 and 14.55. Algorithm 1's
  # loop bound of [2 .. LENGTH(ar) - 1] would drop the second.
  expect_equal(cull_ratios(c(4.23, 14.55), scale_factor = 1.25), c(4.23, 14.55))
})

test_that("cull_ratios compares against the last kept ratio, not the last candidate", {
  # 4.4 is culled against 4 (ratio 1.1). 5.4 must then be compared against the
  # kept 4 (ratio 1.35, kept) rather than the discarded 4.4 (ratio 1.23, which
  # would wrongly cull it and let the series drift arbitrarily far).
  expect_equal(cull_ratios(c(4, 4.4, 5.4), scale_factor = 1.25), c(4, 5.4))
})

test_that("cull_ratios compares ratios symmetrically, whichever is larger", {
  expect_equal(cull_ratios(c(20, 4), scale_factor = 1.25), c(20, 4))
})

# bank_slopes_multiscale() --------------------------------------------------

two_scale_signal <- function(n = 256) {
  i <- seq_len(n)
  # Two well-separated components: a slow 3-cycle trend and a fast 30-cycle
  # oscillation, with the slow one carrying more energy.
  3 * sin(2 * pi * 3 * i / n) + sin(2 * pi * 30 * i / n)
}

test_that("bank_slopes_multiscale returns frequency, ratio and aspect_ratio columns", {
  out <- bank_slopes_multiscale(two_scale_signal())
  expect_s3_class(out, "tbl_df")
  expect_named(out, c("frequency", "ratio", "aspect_ratio"))
  expect_type(out$frequency, "integer")
})

test_that("bank_slopes_multiscale reports aspect_ratio as the reciprocal of ratio", {
  # `ratio` feeds coord_fixed() (height per unit width); `aspect_ratio` is the
  # width/height convention the banking literature reports.
  out <- bank_slopes_multiscale(two_scale_signal())
  expect_equal(out$aspect_ratio, 1 / out$ratio)
})

test_that("bank_slopes_multiscale recovers both components of a two-scale signal", {
  out <- bank_slopes_multiscale(two_scale_signal())
  expect_true(any(abs(out$frequency - 3) <= 1))
  expect_true(any(abs(out$frequency - 30) <= 1))
})

test_that("bank_slopes_multiscale gives a wider chart for the higher-frequency scale", {
  # Higher frequency means steeper segments, so banking flattens them: the
  # aspect ratio must increase with frequency.
  out <- bank_slopes_multiscale(two_scale_signal())
  expect_true(all(diff(out$aspect_ratio) > 0))
})

test_that("bank_slopes_multiscale returns frequencies in ascending order", {
  out <- bank_slopes_multiscale(two_scale_signal())
  expect_equal(out$frequency, sort(out$frequency))
})

test_that("bank_slopes_multiscale raising the threshold selects fewer scales", {
  y <- two_scale_signal()
  z <- smooth_spectrum(power_spectrum(y), window = 3, sd = 1)
  low <- bank_slopes_multiscale(y, threshold = mean(z))
  high <- bank_slopes_multiscale(y, threshold = max(z) * 2)
  expect_gt(nrow(low), nrow(high))
})

test_that("bank_slopes_multiscale always returns the entire-data scale", {
  y <- two_scale_signal()
  out <- bank_slopes_multiscale(y, threshold = Inf)
  expect_equal(nrow(out), 1L)
  expect_equal(out$frequency, length(y) %/% 2L)
})

test_that("bank_slopes_multiscale accepts the other banking methods", {
  y <- two_scale_signal()
  expect_false(isTRUE(all.equal(
    bank_slopes_multiscale(y, method = "ms")$ratio,
    bank_slopes_multiscale(y, method = "ao")$ratio
  )))
})

test_that("bank_slopes_multiscale rejects missing values", {
  y <- two_scale_signal()
  y[10] <- NA
  expect_error(bank_slopes_multiscale(y), regexp = "missing")
})

test_that("bank_slopes_multiscale rejects non-finite values", {
  y <- two_scale_signal()
  y[10] <- Inf
  expect_error(bank_slopes_multiscale(y), regexp = "finite")
})

test_that("bank_slopes_multiscale rejects a series too short to have a spectrum", {
  expect_error(bank_slopes_multiscale(c(1, 2, 3)), regexp = "at least")
})

test_that("bank_slopes_multiscale rejects non-numeric input", {
  expect_error(bank_slopes_multiscale(letters), regexp = "numeric")
})

# Reproduction of published results ------------------------------------------

test_that("bank_slopes_multiscale finds the paper's candidate scales for sunspots", {
  # Section 3.2.1: "Spectral analysis finds four scales of interest, at
  # frequency indices 7, 10, 31, and 36, plus the scale of the data in its
  # entirety."
  y <- as.numeric(sunspot.year)
  z <- smooth_spectrum(power_spectrum(y), window = 3, sd = 1)
  expect_equal(select_scales(z, mean(z)), c(7L, 10L, 31L, 36L, length(y) %/% 2L))
})

test_that("bank_slopes_multiscale culls the sunspot scales to the paper's two charts", {
  # Section 3.2.1: "Filtering the aspect ratios yields two charts,
  # corresponding to frequency scales 7 and 31."
  expect_equal(bank_slopes_multiscale(as.numeric(sunspot.year))$frequency, c(7L, 31L))
})

test_that("bank_slopes_multiscale reproduces the paper's sunspot aspect ratios", {
  # Section 3.2.1 reports 3.96 and 22.35. We get 3.95 and 21.66. The frequency
  # indices match exactly; the ratios differ by under 4%, attributable to the
  # source series (the paper used 1700-1987, R's sunspot.year runs to 1988)
  # and to unspecified details of their low-pass filter. The tolerance is wide
  # enough to absorb that but not a structurally different result: keeping the
  # DC term, for instance, selects scales 5 and 31 and fails outright.
  out <- bank_slopes_multiscale(as.numeric(sunspot.year))
  expect_equal(out$aspect_ratio, c(3.96, 22.35), tolerance = 0.04)
})

# bank_plot_multiscale() -----------------------------------------------------

two_scale_df <- data.frame(x = seq_along(two_scale_signal()), y = two_scale_signal())

test_that("bank_plot_multiscale returns one ggplot per scale", {
  p <- ggplot2::ggplot(two_scale_df, ggplot2::aes(x, y)) + ggplot2::geom_line()
  out <- bank_plot_multiscale(p)
  expect_type(out, "list")
  expect_equal(length(out), nrow(bank_slopes_multiscale(two_scale_signal())))
  expect_true(all(vapply(out, ggplot2::is_ggplot, logical(1))))
})

test_that("bank_plot_multiscale applies the ratio computed for each scale", {
  p <- ggplot2::ggplot(two_scale_df, ggplot2::aes(x, y)) + ggplot2::geom_line()
  expected <- bank_slopes_multiscale(two_scale_signal())
  out <- bank_plot_multiscale(p)
  expect_equal(vapply(out, function(p) p$coordinates$ratio, numeric(1)), expected$ratio, ignore_attr = TRUE)
})

test_that("bank_plot_multiscale names each element by its frequency", {
  p <- ggplot2::ggplot(two_scale_df, ggplot2::aes(x, y)) + ggplot2::geom_line()
  expected <- bank_slopes_multiscale(two_scale_signal())
  out <- bank_plot_multiscale(p)
  expect_equal(names(out), as.character(expected$frequency))
})

test_that("bank_plot_multiscale rejects unevenly spaced x", {
  # The DFT underlying multi-scale banking is only defined on a regular grid.
  df <- data.frame(x = c(1, 2, 4, 8, 16, 32, 64, 128), y = rnorm(8))
  p <- ggplot2::ggplot(df, ggplot2::aes(x, y)) + ggplot2::geom_line()
  expect_error(bank_plot_multiscale(p), regexp = "evenly spaced")
})

test_that("bank_plot_multiscale rejects a plot with more than one series", {
  y <- two_scale_signal(64)
  df <- data.frame(x = rep(seq_len(64), 2), y = c(y, rev(y)), g = rep(c("a", "b"), each = 64))
  p <- ggplot2::ggplot(df, ggplot2::aes(x, y, group = g)) + ggplot2::geom_line()
  expect_error(bank_plot_multiscale(p), regexp = "single series")
})

test_that("bank_plot_multiscale errors for an out-of-range layer index", {
  p <- ggplot2::ggplot(two_scale_df, ggplot2::aes(x, y)) + ggplot2::geom_line()
  expect_error(bank_plot_multiscale(p, layer = 2), regexp = "layer")
  expect_error(bank_plot_multiscale(p, layer = 0), regexp = "layer")
})
