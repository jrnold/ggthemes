test_that("excel_clasic_pal works", {
  pal <- excel_pal()
  n <- 5L
  values <- pal(n)
  expect_type(values, "character")
  expect_equal(length(values), n)
})

test_that("excel_clasic_pal with line = TRUE works", {
  pal <- excel_pal(line = TRUE)
  n <- 5L
  values <- pal(n)
  expect_type(values, "character")
  expect_equal(length(values), n)
})

test_that("calc_shape_pal raises warning for large n", {
  expect_snapshot(x <- excel_pal()(8))
})

test_that("excel_new_pal works", {
  pal <- excel_new_pal()
  n <- 5L
  vals <- pal(n)
  expect_type(vals, "character")
  expect_equal(length(vals), n)
})

test_that("excel_new_pal raises error for bad n", {
  expect_snapshot(x <- excel_new_pal()(7))
})

test_that("theme_excel works", {
  expect_s3_class(theme_excel(), "theme")
})

test_that("theme_excel respects base_family and base_size", {
  thm <- theme_excel(base_family = "mono", base_size = 20)
  expect_equal(thm$text$family, "mono")
  expect_equal(thm$text$size, 20)
})

test_that("excel_new_pal raises error with bad theme name", {
  expect_snapshot(excel_new_pal("adfaasdfa"), error = TRUE)
})

test_that("scale_fill_excel works", {
  expect_s3_class(scale_fill_excel(), "ScaleDiscrete")
})

test_that("scale_colour_excel works", {
  expect_s3_class(scale_colour_excel(), "ScaleDiscrete")
})

test_that("scale_colour_excel works", {
  expect_s3_class(scale_fill_excel_new(), "ScaleDiscrete")
})

test_that("scale_fill_excel works", {
  expect_s3_class(scale_colour_excel_new(), "ScaleDiscrete")
})

test_that("theme_excel with horizontal = FALSE works", {
  thm <- theme_excel(horizontal = FALSE)
  expect_equal(thm$panel.grid.major.y, element_blank())
})

test_that("theme_excel_new respects base_size for all text elements", {
  thm <- theme_excel_new(base_size = 20)
  expect_equal(thm$text$size, 20)
  expect_equal(thm$axis.text$size, 20)
  expect_equal(thm$strip.text$size, 20)
  expect_equal(thm$legend.text$size, 20)
})

test_that("theme_excel_new does not blank out axis titles", {
  thm <- theme_excel_new()
  expect_false(inherits(thm$axis.title, "element_blank"))
})

# Excel derives chart chrome from tx1 (black) by luminance transform. The
# values below are decoded from xl/charts/style1.xml and xl/charts/chart1.xml
# in data-raw/excel/mtcars.xlsx, written by Microsoft Excel 16.03.

test_that("theme_excel_new uses Excel's gridline grey", {
  # tx1 lumMod 15% / lumOff 85%
  thm <- theme_excel_new()
  expect_equal(thm$panel.grid.major$colour, "#D9D9D9")
})

test_that("theme_excel_new draws axis lines in Excel's axis grey", {
  # tx1 lumMod 25% / lumOff 75%, drawn on both axes
  thm <- theme_excel_new()
  expect_s3_class(thm$axis.line, "element_line")
  expect_equal(thm$axis.line$colour, "#BFBFBF")
})

test_that("theme_excel_new draws gridlines and axis lines at 0.75pt", {
  # w="9525" EMU = 0.75pt
  thm <- theme_excel_new()
  expect_equal(thm$panel.grid.major$linewidth, 0.75 * PT_TO_MM)
  expect_equal(thm$axis.line$linewidth, 0.75 * PT_TO_MM)
})

test_that("theme_excel_new sizes axis titles above axis text", {
  # axisTitle sz="1000" (10pt) against categoryAxis/valueAxis sz="900" (9pt)
  thm <- theme_excel_new(base_size = 9)
  expect_equal(ggplot2::calc_element("axis.title.x", thm)$size, 10)
  expect_equal(ggplot2::calc_element("axis.text.x", thm)$size, 9)
})

test_that("theme_excel_new scales axis titles with base_size", {
  thm <- theme_excel_new(base_size = 18)
  expect_equal(ggplot2::calc_element("axis.title.x", thm)$size, 20)
})

test_that("excel_new_pal defaults to the current Office theme", {
  expect_equal(
    excel_new_pal()(6),
    c("#156082", "#E97132", "#196B24", "#0F9ED5", "#A02B93", "#4EA72E")
  )
})

test_that("excel_new_pal returns the Office 2013 palette", {
  expect_equal(
    excel_new_pal("Office 2013")(6),
    c("#4472C4", "#ED7D31", "#A5A5A5", "#FFC000", "#5B9BD5", "#70AD47")
  )
})

test_that("excel_new_pal accepts superseded theme names", {
  expect_equal(excel_new_pal("Office Theme")(6), excel_new_pal("Office 2013")(6))
  expect_equal(
    excel_new_pal("Office 2007-2010")(6),
    excel_new_pal("Office 2007")(6)
  )
})

test_that("excel_new_pal resolves superseded names silently", {
  expect_silent(excel_new_pal("Office Theme"))
  expect_silent(excel_new_pal("Office 2007-2010"))
})

test_that("excel_resolve_theme leaves other names untouched", {
  expect_equal(excel_resolve_theme("Berlin"), "Berlin")
  expect_equal(excel_resolve_theme("Office"), "Office")
  expect_equal(excel_resolve_theme(character(0)), character(0))
})

test_that("scale_*_excel_new default to the current Office theme", {
  expect_equal(formals(scale_colour_excel_new)$theme, "Office")
  expect_equal(formals(scale_fill_excel_new)$theme, "Office")
})

test_that("theme_excel draws correctly", {
  expect_doppelganger("theme_excel", theme_test_plot() + theme_excel())
})

test_that("theme_excel_new draws correctly", {
  expect_doppelganger("theme_excel_new", theme_test_plot() + theme_excel_new())
})
