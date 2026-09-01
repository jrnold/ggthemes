test_that("stata_pal works", {
  p <- stata_pal("s2color")
  expect_type(p, "closure")
  expect_type(attr(p, "max_n"), "integer")
  n <- 5
  vals <- p(n)
  expect_hexcolor(vals)
  expect_length(vals, n)
  expect_warning(stata_pal("s2color")(100))
})

test_that("scale_colour_stata works", {
  expect_s3_class(scale_colour_stata("s2color"), "ScaleDiscrete")
})

test_that("scale_color_stata works", {
  expect_equal_scale(scale_colour_stata("s2color"), scale_color_stata("s2color"))
})

test_that("scale_fill_stata works", {
  expect_s3_class(scale_fill_stata("s2color"), "ScaleDiscrete")
})

test_that("scale_shape_stata works", {
  expect_s3_class(scale_shape_stata(), "ScaleDiscrete")
})

test_that("theme_stata works", {
  expect_s3_class(theme_stata(scheme = "s2color"), "theme")
  for (i in c("s2mono", "s1mono", "s2manual", "s1rcolor", "s1color")) {
    expect_s3_class(theme_stata(scheme = i), "theme")
  }
})

test_that("theme_state raises error with invallid scheme", {
  expect_error(theme_stata(scheme = "dsagasagdadgaga"), regexp = "`scheme` must be one of")
})

test_that("stata_shape_pal works", {
  p <- stata_shape_pal()
  expect_type(p, "closure")
  n <- 5L
  vals <- p(n)
  expect_type(vals, "integer")
  expect_length(vals, n)
  expect_true(all(vals < 0))
  expect_warning(p(100))
})

test_that("stata_linetype_pal works", {
  p <- stata_linetype_pal()
  expect_type(p, "closure")
  n <- 5L
  vals <- p(n)
  expect_equal(vals, c("solid", "84", "23", "F414", "F4"))
})

test_that("scale_linetype_stata works", {
  expect_s3_class(scale_linetype_stata(), "ScaleDiscrete")
})

# Palette contents verified against the official scheme files shipped in
# Stata's ado/base/s (see data-raw/theme-data/stata.yml for provenance).

test_that("stata_pal() reports its true maximum n", {
  for (scheme in names(ggthemes_data[["stata"]][["colors"]][["schemes"]])) {
    expect_equal(attr(stata_pal(scheme), "max_n"), 15L, info = scheme)
  }
})

test_that("no stata scheme contains an unresolved color", {
  schemes <- ggthemes_data[["stata"]][["colors"]][["schemes"]]
  for (scheme in names(schemes)) {
    expect_false(anyNA(schemes[[scheme]][["value"]]), info = scheme)
  }
})

test_that("mono scheme matches Stata's s1mono/s2mono p1-p15", {
  expect_equal(
    ggthemes_data[["stata"]][["colors"]][["schemes"]][["mono"]][["name"]],
    c(
      "gs6",
      "gs10",
      "gs8",
      "gs4",
      "black",
      "gs12",
      "gs2",
      "gs7",
      "gs9",
      "gs11",
      "gs13",
      "gs5",
      "gs3",
      "gs12",
      "gs5"
    )
  )
})

test_that("economist scheme matches Stata's scheme-economist p1-p15", {
  expect_equal(
    ggthemes_data[["stata"]][["colors"]][["schemes"]][["economist"]][["name"]],
    c(
      "edkblue",
      "emidblue",
      "eltblue",
      "emerald",
      "erose",
      "ebblue",
      "eltgreen",
      "stone",
      "navy",
      "maroon",
      "brown",
      "lavender",
      "teal",
      "cranberry",
      "khaki"
    )
  )
})

test_that("stcolor scheme uses the Stata 18 stc1-stc15 colors", {
  expect_equal(
    unname(stata_pal("stcolor")(15)),
    c(
      "#1a85ff",
      "#d41159",
      "#00bf7f",
      "#ffd400",
      "#4f2c99",
      "#ff6333",
      "#4db7ff",
      "#7c0015",
      "#0fefaf",
      "#faa307",
      "#758bfd",
      "#fed9b7",
      "#08234c",
      "#f88dad",
      "#0f5156"
    )
  )
})

test_that("theme_stata() supports the Stata 18 st-family schemes", {
  for (scheme in c("stcolor", "stcolor_alt", "stmono1", "stmono2", "stsj")) {
    expect_s3_class(theme_stata(scheme = scheme), "theme")
  }
})

test_that("stcolor matches the reference graph's key colors", {
  th <- theme_stata(scheme = "stcolor")
  # Values read from Stata 18-generated SVGs; see data-raw/reference/stata.
  expect_equal(th[["panel.background"]][["fill"]], "white")
  expect_equal(th[["plot.background"]][["fill"]], "white")
  expect_equal(tolower(th[["panel.grid.major"]][["colour"]]), "#f0f0f0")
  expect_equal(tolower(th[["strip.background"]][["fill"]]), "#f0f0f0")
  expect_equal(th[["legend.position"]], "right")
})

test_that("omitting scheme is soft-deprecated", {
  lifecycle::expect_deprecated(stata_pal())
  lifecycle::expect_deprecated(theme_stata())
  lifecycle::expect_deprecated(scale_colour_stata())
  lifecycle::expect_deprecated(scale_fill_stata())
})
