# The shape tables in `ggthemes_data` are generated from YAML by
# `data-raw/build.R`, which validates them as it builds. That validation is
# re-run here against the *built* data, so a stale `data/ggthemes_data.rda`
# fails R CMD check instead of passing quietly (the build script is not run
# during a check).

test_that("every shape row carries a canonical shape name", {
  for (nm in names(shape_tables())) {
    tbl <- shape_tables()[[nm]]
    expect_true("shape" %in% names(tbl), label = paste0(nm, " has a `shape` column"))
    expect_false(any(is.na(tbl$shape)), label = paste0(nm, " has no missing shape name"))
  }
})

test_that("every shape name is in the closed vocabulary", {
  for (nm in names(shape_tables())) {
    unknown <- setdiff(shape_tables()[[nm]]$shape, names(shape_pch))
    expect_equal(unknown, character(0), label = paste0(nm, " unknown shape names"))
  }
})

test_that("the safe pch of every row is the one its shape name denotes", {
  for (nm in names(shape_tables())) {
    tbl <- shape_tables()[[nm]]
    expect_equal(
      unname(tbl$pch),
      unname(shape_pch[tbl$shape]),
      label = paste0(nm, " derived pch")
    )
  }
})

test_that("every safe pch is font-independent or NA", {
  for (nm in names(shape_tables())) {
    tbl <- shape_tables()[[nm]]
    expect_true(all(is_safe_pch(tbl$pch)), label = paste0(nm, " safe pch in range"))
  }
})

test_that("the character column agrees with the unicode column", {
  for (nm in names(shape_tables())) {
    tbl <- shape_tables()[[nm]]
    expect_equal(
      character_codepoint(tbl$character),
      unicode_codepoint(shape_unicode(tbl)),
      label = paste0(nm, " character/unicode agreement")
    )
  }
})

test_that("pch_unicode is the negated codepoint of the character", {
  for (nm in names(shape_tables())) {
    tbl <- shape_tables()[[nm]]
    expect_equal(
      unname(tbl$pch_unicode),
      -character_codepoint(tbl$character),
      label = paste0(nm, " pch_unicode")
    )
  }
})

test_that("no palette selects the same safe pch twice", {
  # Checked per palette, not per table: `stata/shapes` is a 22-row catalogue
  # that legitimately collapses `smcircle` and `circle` onto pch 16, because
  # pch encodes symbol identity and delegates size to the `size` aesthetic.
  # `stata_shape_pal()` never selects both, so no palette is affected.
  palettes <- list(
    "cleveland overlap" = cleveland_shape_pal(overlap = TRUE),
    "cleveland default" = cleveland_shape_pal(overlap = FALSE),
    "few" = few_shape_pal(),
    "calc" = calc_shape_pal(),
    "stata" = stata_shape_pal(),
    "tableau default" = tableau_shape_pal("default"),
    "tableau filled" = tableau_shape_pal("filled"),
    "tableau proportions" = tableau_shape_pal("proportions")
  )
  for (nm in names(palettes)) {
    values <- palettes[[nm]](attr(palettes[[nm]], "max_n"))
    expect_equal(anyDuplicated(values), 0L, label = paste0(nm, " duplicate pch"))
  }
})

# --- Data corrections -------------------------------------------------------

test_that("cleveland's overlap palette uses S, not W", {
  # The stored row read `{name: LATIN CAPITAL LETTER S, unicode: U+0053,
  # pch: 87}`. pch 87 is the ASCII codepoint of `W`; `S` is 83.
  overlap <- ggthemes::ggthemes_data$shapes$cleveland$overlap
  expect_equal(overlap$pch[[4]], 83L)
  expect_equal(overlap$character[[4]], "S")
})

test_that("LibreOffice's down-pointing triangle is named a triangle", {
  calc <- ggthemes::ggthemes_data$calc$shapes
  expect_true("BLACK DOWN-POINTING TRIANGLE" %in% calc$name)
  expect_false("BLACK DOWN-POINTING CHARACTER" %in% calc$name)
})

test_that("Tableau's weather palette stores a real cloud-with-rain character", {
  weather <- ggthemes::ggthemes_data$tableau[["shape-palettes"]]$weather
  rain <- weather[weather$name == "CLOUD WITH RAIN", ]
  expect_equal(character_codepoint(rain$character), 0x1F327L)
})

test_that("Excel's em dash names the codepoint it stores", {
  # The row carried `unicode: U+2013` (EN DASH) against an EM DASH character.
  excel <- ggthemes::ggthemes_data$excel$shapes
  dash <- excel[excel$name == "EM DASH", ]
  expect_equal(dash$unicode, "U+2014")
})

# --- Tremmel (1995) ---------------------------------------------------------
#
# The stored sets contradicted the roxygen in three of five entries. Verified
# against Tremmel (1995), JCGS 4(2), 101-112, §5.1 and §5.2; the roxygen is
# right in every disputed case.

test_that("tremmel n = 2 is a solid circle and a plus sign", {
  # §5.1: "One group should be represented by solid circles or rings, and the
  # other group by plus signs or asterisks."
  expect_equal(tremmel_shape_pal()(2), c(16L, 3L))
})

test_that("tremmel n = 2 with overlap is an empty circle and a plus sign", {
  # §5.1: "If there is much overlap, empty circles should be taken for the
  # first group because empty symbols preserve their individuality."
  expect_equal(tremmel_shape_pal(overlap = TRUE)(2), c(1L, 3L))
})

test_that("tremmel n = 3 is a solid circle, empty circle and empty triangle", {
  expect_equal(tremmel_shape_pal()(3), c(16L, 1L, 2L))
})

test_that("tremmel's alternate n = 3 differs from the default set", {
  # §5.2's feature-dimension triple: solid circle, plus sign, empty triangle.
  # The stored `3-alternate` was identical to `3`, making `alt` a no-op.
  expect_equal(tremmel_shape_pal(alt = TRUE)(3), c(16L, 3L, 2L))
  expect_false(identical(tremmel_shape_pal(alt = TRUE)(3), tremmel_shape_pal()(3)))
})
