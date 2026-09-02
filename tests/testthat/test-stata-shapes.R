# `stata_shape_pal()` picks ten symbolstyles out of Stata's 22-row catalogue by
# name. Two things can go wrong with a lookup by name, and neither used to be
# caught: the name can stop matching the data, and the list of names can be
# duplicated somewhere that then drifts.

test_that("the palette symbolstyles are the canonical list", {
  expect_type(stata_palette_shapes, "character")
  expect_length(stata_palette_shapes, 10L)
  expect_false(anyDuplicated(stata_palette_shapes) > 0L)
})

# The drift this guards: a `symbolstyle` renamed in stata.yml, or a name edited
# in the canonical list, silently produced an all-`NA` row.
test_that("every palette symbolstyle exists in the shape catalogue", {
  catalogue <- ggthemes::ggthemes_data[["stata"]][["shapes"]][["symbolstyle"]]
  expect_equal(setdiff(stata_palette_shapes, catalogue), character(0))
})

test_that("stata_shape_rows() returns the requested rows in order", {
  statadata <- ggthemes::ggthemes_data[["stata"]][["shapes"]]
  rows <- stata_shape_rows(statadata, c("square", "circle"))
  expect_equal(rows[["symbolstyle"]], c("square", "circle"))
})

# Before this, `match()` yielded an all-`NA` row, `new_shape_pal()` dropped it
# as "no font-independent equivalent", and `max_n` quietly fell below the
# documented ten with no error anywhere.
test_that("stata_shape_rows() aborts on a symbolstyle the data lacks", {
  statadata <- ggthemes::ggthemes_data[["stata"]][["shapes"]]
  expect_error(
    stata_shape_rows(statadata, c("circle", "pentagram")),
    "pentagram"
  )
})

test_that("stata_shape_rows() names every missing symbolstyle, not just one", {
  statadata <- ggthemes::ggthemes_data[["stata"]][["shapes"]]
  err <- expect_error(stata_shape_rows(statadata, c("pentagram", "obelisk")))
  expect_match(conditionMessage(err), "pentagram")
  expect_match(conditionMessage(err), "obelisk")
})

test_that("stata_shape_pal() supports one value per canonical symbolstyle", {
  expect_equal(attr(stata_shape_pal(), "max_n"), length(stata_palette_shapes))
  expect_equal(
    attr(suppressWarnings(stata_shape_pal(unicode = TRUE)), "max_n"),
    length(stata_palette_shapes)
  )
})

# `data-raw/build.R` checks for duplicate pch over the ten palette symbolstyles
# rather than the whole catalogue, so it needs the same list. Holding a second
# copy meant an edit to one could leave the duplicate check running over the
# stale set -- the drift `R/shape-names.R` is `source()`d to prevent.
test_that("build.R sources the canonical list instead of copying it", {
  build <- testthat::test_path("..", "..", "data-raw", "build.R")
  skip_if_not(file.exists(build), "data-raw/ is not shipped with the package")
  src <- readLines(build, warn = FALSE)
  expect_true(any(grepl('source(here::here("R", "stata-shapes.R"))', src, fixed = TRUE)))
  expect_false(any(grepl("STATA_PALETTE_SHAPES", src, fixed = TRUE)))
})
