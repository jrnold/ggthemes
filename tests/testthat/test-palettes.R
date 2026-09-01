# Family-wide palette checks (#219).
#
# The palette-specific regressions from #217 live in test-tableau.R. These are
# their general form: the same properties asserted over every palette in a
# family, so that the next corrupted value is caught wherever it lands rather
# than only where someone thought to look.

# The thresholds below are empirical. Every current palette passes them with
# room to spare, and all three of the #217 bugs fail them:
#
#   Gray Warm[7]  "#b047a4"  -> lightness reversal and step outlier
#   Gray Warm[18] "#665c51"  -> grey ramp channel reversal
#   Red-Gold      duplicate  -> duplicate colour and length snapshot
#
# Worst observed ratio is 3.14 for sequential and 6.29 for diverging.
max_step_ratio <- c("ordered-sequential" = 4, "ordered-diverging" = 8)

ordered_families <- names(max_step_ratio)

all_families <- c(ordered_families, "regular")

# Sequential ramps that are meant to be neutral greys.
grey_ramps <- c("Gray", "Gray Warm", "Classic Gray")

test_that("every tableau palette is valid hex", {
  for (family in all_families) {
    pals <- tableau_palette_colours(family)
    bad <- names(pals)[
      !vapply(pals, function(x) all(grepl("^#[0-9A-Fa-f]{6}$", x)), logical(1))
    ]
    expect_equal(bad, character(0), info = family)
  }
})

test_that("no tableau palette repeats a colour", {
  for (family in all_families) {
    pals <- tableau_palette_colours(family)
    bad <- names(pals)[
      vapply(pals, function(x) anyDuplicated(tolower(x)) > 0L, logical(1))
    ]
    expect_equal(bad, character(0), info = family)
  }
})

test_that("ordered palette lengths are stable", {
  # A palette that gains or loses a colour changes this snapshot. Red-Gold
  # shipped with 21 colours where every other 20-step ramp has 20 (#217).
  sequential <- vapply(
    tableau_palette_colours("ordered-sequential"),
    length,
    integer(1)
  )
  diverging <- vapply(
    tableau_palette_colours("ordered-diverging"),
    length,
    integer(1)
  )
  expect_snapshot(sequential)
  expect_snapshot(diverging)
})

test_that("sequential palettes run monotonically in lightness", {
  pals <- tableau_palette_colours("ordered-sequential")
  bad <- names(pals)[!vapply(pals, is_monotone_lightness, logical(1))]
  expect_equal(bad, character(0))
})

test_that("ordered palettes contain no out-of-family colour", {
  for (family in ordered_families) {
    pals <- tableau_palette_colours(family)
    ratios <- vapply(pals, step_outlier_ratio, numeric(1))
    offenders <- names(ratios)[ratios > max_step_ratio[[family]]]
    # Name the position too: an SVG diff says "something moved", this says where.
    labels <- vapply(
      offenders,
      function(nm) sprintf("%s[%d]", nm, which.max(lab_steps(pals[[nm]])) + 1L),
      character(1),
      USE.NAMES = FALSE
    )
    expect_equal(labels, character(0), info = family)
  }
})

test_that("grey ramps stay neutral and monotone in every channel", {
  pals <- tableau_palette_colours("ordered-sequential")
  expect_true(all(grey_ramps %in% names(pals)))

  for (nm in grey_ramps) {
    values <- pals[[nm]]
    # Neutral: no colour may sit far off the grey axis.
    expect_lt(max(lab_chroma(values)), 10, label = paste("max chroma of", nm))
    # Monotone: each RGB channel must move in one direction only. Gray Warm[18]
    # broke exactly this, with a blue channel of 96 -> 81 -> 84 (#217).
    channels <- grDevices::col2rgb(values)
    reversed <- rownames(channels)[apply(channels, 1, function(ch) {
      d <- diff(ch)
      !(all(d >= 0) || all(d <= 0))
    })]
    expect_equal(reversed, character(0), info = nm)
  }
})

test_that("tableau ordered-sequential palettes draw correctly", {
  expect_doppelganger(
    "palettes-tableau-ordered-sequential",
    swatch_plot(
      tableau_palette_colours("ordered-sequential"),
      "Tableau ordered-sequential"
    )
  )
})

test_that("tableau ordered-diverging palettes draw correctly", {
  expect_doppelganger(
    "palettes-tableau-ordered-diverging",
    swatch_plot(
      tableau_palette_colours("ordered-diverging"),
      "Tableau ordered-diverging"
    )
  )
})

test_that("tableau regular palettes draw correctly", {
  expect_doppelganger(
    "palettes-tableau-regular",
    swatch_plot(tableau_palette_colours("regular"), "Tableau regular")
  )
})

test_that("discrete palettes draw correctly", {
  expect_doppelganger(
    "palettes-discrete",
    swatch_plot(discrete_palette_colours(), "Discrete palettes")
  )
})
