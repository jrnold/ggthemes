# Helpers for the palette property assertions in test-palettes.R.
#
# The properties are expressed in CIE Lab rather than RGB: lightness (L*) is
# what makes a sequential ramp "sequential", and Euclidean distance in Lab is a
# far better proxy for "these two colours look adjacent" than distance in RGB.

# The `value` column of every palette in one of the `ggthemes_data$tableau`
# palette families, as a named list of character vectors.
tableau_palette_colours <- function(family) {
  palettes <- ggthemes::ggthemes_data$tableau$`color-palettes`[[family]]
  lapply(palettes, function(x) x$value)
}

lab_values <- function(x) farver::decode_colour(x, to = "lab")

# Perceptual distance between each pair of adjacent colours in a ramp.
lab_steps <- function(x) sqrt(rowSums(diff(lab_values(x))^2))

# Distance from the neutral axis. A grey has a chroma near zero whatever its
# lightness, so this is how a grey ramp is recognised.
lab_chroma <- function(x) {
  m <- lab_values(x)
  sqrt(m[, "a"]^2 + m[, "b"]^2)
}

# TRUE when lightness runs consistently in one direction along the ramp. The
# tolerance absorbs rounding: "Blue" reverses by 0.064 L* at one step, which is
# invisible, while the magenta that #217 removed from "Gray Warm" reversed by
# tens of units.
is_monotone_lightness <- function(x, tolerance = 0.5) {
  d <- diff(lab_values(x)[, "l"])
  all(d > -tolerance) || all(d < tolerance)
}

# The largest step relative to the typical step. An out-of-family colour shows
# up as one abnormally long jump in and one back out again.
step_outlier_ratio <- function(x) {
  s <- lab_steps(x)
  max(s) / stats::median(s)
}

# Discrete palettes drawn from across the package, with the number of colours
# each is asked for. The counts are written out rather than taken from
# `max_n` so that a change in a palette's maximum shows up as a test failure
# rather than silently redrawing the baseline.
discrete_palette_colours <- function() {
  # `ptol_pal()` is deprecated; its colours are still covered here so the
  # baseline keeps guarding them until the function is removed.
  withr::local_options(lifecycle_verbosity = "quiet")
  specs <- list(
    calc = list(calc_pal(), 12L),
    canva = list(canva_pal(), 4L),
    colorblind = list(colorblind_pal(), 8L),
    economist = list(economist_pal(), 9L),
    excel = list(excel_pal(), 7L),
    excel_new = list(excel_new_pal(), 6L),
    few = list(few_pal(), 8L),
    fivethirtyeight = list(fivethirtyeight_pal(), 3L),
    gdocs = list(gdocs_pal(), 20L),
    hc = list(hc_pal(), 10L),
    numbers = list(numbers_pal(), 6L),
    ptol = list(ptol_pal(), 12L),
    solarized = list(solarized_pal(), 8L),
    # `scheme` is passed explicitly: its default changes in 7.0.0, and a
    # baseline should move only when someone means to move it.
    stata = list(stata_pal(scheme = "s2color"), 15L),
    wsj = list(wsj_pal(), 6L)
  )
  lapply(specs, function(spec) spec[[1]](spec[[2]]))
}
