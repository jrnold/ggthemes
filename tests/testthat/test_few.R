context("few")

expect_that("theme_few draws correctly", {
  p <- ggplot(mtcars) +
    geom_point(aes(x = wt, y = mpg,  colour = factor(gear))) +
    facet_wrap(~am)

  expect_doppelganger("theme_few with medium colors", {
    p + theme_few() + scale_colour_few()
  })
  expect_doppelganger("theme_few with light colors", {
    p + theme_few() + scale_colour_few("light")
  })
  expect_doppelganger("theme_few with dark colors", {
    p + theme_few() + scale_colour_few("dark")
  })

})
