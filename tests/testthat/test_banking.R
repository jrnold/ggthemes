context("Testing banking functions")

# Compare the banking functions to the results in Table 1
# of Heer et. al. for the columns "co2" and "sun"

data("sunspot.year", package = "datasets")
data("co2", package = "datasets")

tests <-
list(list(params = list(method = 'ms', weight = FALSE, cull = FALSE),
          name = "median-slope (ms)",
          sunspots = 21.88, co2 = 9.19),
     list(params = list(method = "ms", weight = FALSE, cull = TRUE),
          name = "median-slope culled (msc)",
          sunspots = 21.88, co2 = 9.19),
     list(params = list(method = "as", weight = FALSE, cull = FALSE),
          name = "average-slope (as)",
          sunspots = 26.78, co2 = 9.19),
     list(params = list(method = "as", weight = FALSE, cull = TRUE),
          name = "average-slope culled (asc)",
          sunspots = 26.88, co2 = 9.22),
     list(params = list(method = 'ao', weight = FALSE, cull = FALSE),
          name = "average-orient (ao)",
          sunspots = 18.74, co2 = 7.94),
     list(params = list(method = "ao", weight = FALSE, cull = TRUE),
          name = "average-orient culled (aoc)",
          sunspots = 18.88, co2 = 7.98),
     list(params = list(method = "ao", weight = TRUE, cull = FALSE),
          name = "average-weighted-orient (awo)",
          sunspots = 26.60, co2 = 9.14),
     list(params = list(method = "ao", weight = TRUE, cull = TRUE),
          name = "average-weighted-orient culled (awoc)",
          sunspots = 26.69, co2 = 9.17),
     list(params = list(method = 'gor', weight = FALSE, cull = FALSE),
          name = "global-orient-resolution (gor)",
          sunspots = 19.26, co2 = 8.02),
     list(params = list(method = "gorc", weight = FALSE, cull = TRUE),
          name = "global-orient-resolution culled (gorc)",
          sunspots = 19.37, co2 = 8.05),
     list(params = list(method = "lor", weight = TRUE, cull = FALSE),
          name = "local-orient-resolution",
          sunspots = 16.28, co2 = 6.41),
     list(params = list(method = "lor", weight = TRUE, cull = TRUE),
          name = "local-orient-resolution culled (awoc)",
          sunspots = 16.44, co2 = 6.45)
)

for (tst in tests) {
  params <- tst[["params"]]
  test_name <- tst[["name"]]

  test_that(sprintf("%s produces correct aspect ratio for the sunspot data", test_name), {
    x <- seq_along(sunspot.year)
    y <- as.numeric(sunspot.year)
    alpha <- round(1 / bank_slopes(x, y,
                                   method = params[["method"]],
                                   weight = params[["weight"]],
                                   cull = params[["cull"]]), 2)
    expect_equal(alpha, tst[["sunspots"]])
  })

  test_that(sprintf("%s produces correct aspect ratio for the co2 data", test_name), {
    x <- seq_along(co2)
    y <- as.numeric(co2)
    alpha <- round(1 / bank_slopes(x, y,
                                   method = params[["method"]],
                                   weight = params[["weight"]],
                                   cull = params[["cull"]]), 2)
    expect_equal(alpha, tst[["co2"]])
  })

}

