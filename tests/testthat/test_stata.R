context("stata")


library("ggplot2")


test_that("theme_stata draws correctly", {
  p <- ggplot(mtcars) +
    geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
    facet_wrap(~am)

  expect_doppelganger("theme_stata with s2color",
                      p + theme_stata() + scale_colour_stata("s2color")
  )
  # s2mono
  expect_doppelganger("theme_stata with mono", {
    p + theme_stata(scheme = "s2mono") + scale_colour_stata("mono")
  })
  # s1color
  expect_doppelganger("theme_stata with s2color", {
    p + theme_stata(scheme = "s2color") + scale_colour_stata("s1color")
  })
  # s1rcolor
  expect_doppelganger("theme_stata with s1rcolor", {
    p + theme_stata(scheme = "s1rcolor") + scale_colour_stata("s1rcolor")
  })
  # s1mono
  expect_doppelganger("theme_stata with s1mono", {
    p + theme_stata(scheme = "s1mono") + scale_colour_stata("mono")
  })
})
