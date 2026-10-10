# Much of this code is copied from the labeling package.
# nolint start: object_name_linter
.simplicity <- function(q, Q, j, lmin, lmax, lstep) {
  eps <- .Machine$double.eps * 100

  n <- length(Q)
  i <- match(q, Q)[1]
  v <- ifelse(
    (lmin %% lstep < eps ||
      lstep - (lmin %% lstep) < eps) &&
      lmin <= 0 &&
      lmax >= 0,
    1,
    0
  )
  1 - (i - 1) / (n - 1) - j + v
}

.simplicity_max <- function(q, Q, j) {
  n <- length(Q)
  i <- match(q, Q)[1]
  v <- 1
  1 - (i - 1) / (n - 1) - j + v
}

.coverage <- function(dmin, dmax, lmin, lmax) {
  range <- dmax - dmin
  1 - 0.5 * ((dmax - lmax)^2 + (dmin - lmin)^2) / ((0.1 * range)^2)
}

.coverage_max <- function(dmin, dmax, span) {
  range <- dmax - dmin
  if (span > range) {
    half <- (span - range) / 2
    1 - 0.5 * (half^2 + half^2) / ((0.1 * range)^2)
  } else {
    1
  }
}

.density <- function(k, m, dmin, dmax, lmin, lmax) {
  r <- (k - 1) / (lmax - lmin)
  rt <- (m - 1) / (max(lmax, dmax) - min(dmin, lmin))
  2 - max(r / rt, rt / r)
}

.density_max <- function(k, m) {
  if (k >= m) {
    2 - (k - 1) / (m - 1)
  } else {
    1
  }
}

.legibility <- function(lmin, lmax, lstep) {
  1
}

#' Pretty axis breaks inclusive of extreme values
#'
#' This function returns pretty axis breaks that always include the extreme values of the data.
#' This works by calling the extended Wilkinson algorithm (Talbot et al., 2010), constrained to solutions
#' interior to the data range.
#' Then, the minimum and maximum labels are moved to the minimum and maximum of the data
#' range.
#'
#' `extended_range_breaks_` implements the algorithm and returns the break values.
#' `extended_range_breaks` uses the conventions of the scales package, and returns a function.
#'
#' Note that ggplot2 hands a `breaks` function the expanded scale limits, not the data
#' range. Passing `extended_range_breaks()` directly to `breaks` therefore places the
#' end labels at the panel edges rather than at the extremes of the data. To label the extremes,
#' which is what pairs with [geom_rangeframe()], apply the function to the data
#' instead: `scale_x_continuous(breaks = extended_range_breaks()(mtcars$wt))`.
#'
#' @param dmin Minimum of the data range.
#' @param dmax Maximum of the data range.
#' @param n Desired number of breaks.
#' @param Q Set of nice numbers.
#' @param w Weights applied to the four optimization components (simplicity,
#'   coverage, density, and legibility).
#' @return For `extended_range_breaks_`, the vector of axis label locations.
#' For `extended_range_breaks`, a function which takes a single argument, a vector of data, and returns
#'   the vector of axis label locations.
#' @references
#' Talbot, J., Lin, S., Hanrahan, P. (2010) An Extension of Wilkinson's Algorithm
#'   for Positioning Tick Labels on Axes, InfoVis 2010.
#' @author Justin Talbot <jtalbot@@stanford.edu>, Jeffrey B. Arnold, Baptiste Auguie
#' @family tufte
#' @rdname range_breaks
#' @export
#' @example inst/examples/ex-range_breaks.R
extended_range_breaks_ <- function(
  dmin,
  dmax,
  n = 5, # nolint: cyclocomp_linter
  Q = c(1, 5, 2, 2.5, 4, 3), # nolint: object_name_linter
  w = c(0.25, 0.2, 0.5, 0.05)
) {
  eps <- .Machine$double.eps * 100

  if (dmin > dmax) {
    temp <- dmin
    dmin <- dmax
    dmax <- temp
  }

  if (dmax - dmin < eps) {
    # if the range is near the floating point limit,
    # let seq generate some equally spaced steps.
    return(seq(from = dmin, to = dmax, length.out = n))
  }

  best <- list()
  best$score <- -2

  j <- 1
  while (j < Inf) {
    for (q in Q) {
      sm <- .simplicity_max(q, Q, j)

      if ((w[1] * sm + w[2] + w[3] + w[4]) < best$score) {
        j <- Inf
        break
      }

      k <- 2
      while (k < Inf) {
        dm <- .density_max(k, n)
        if ((w[1] * sm + w[2] + w[3] * dm + w[4]) < best$score) {
          break
        }

        delta <- (dmax - dmin) / (k + 1) / j / q
        z <- ceiling(log(delta, base = 10))

        while (z < Inf) {
          step <- j * q * 10^z

          cm <- .coverage_max(dmin, dmax, step * (k - 1))

          if ((w[1] * sm + w[2] * cm + w[3] * dm + w[4]) < best$score) {
            break
          }

          min_start <- floor(dmax / (step)) * j - (k - 1) * j
          max_start <- ceiling(dmin / (step)) * j

          if (min_start > max_start) {
            z <- z + 1
            next
          }

          for (start in min_start:max_start) {
            lmin <- start * (step / j)
            lmax <- lmin + step * (k - 1)
            lstep <- step

            s <- .simplicity(q, Q, j, lmin, lmax, lstep)
            c <- .coverage(dmin, dmax, lmin, lmax)
            g <- .density(k, n, dmin, dmax, lmin, lmax)
            l <- .legibility(lmin, lmax, lstep)

            score <- w[1] * s + w[2] * c + w[3] * g + w[4] * l

            if (
              score > best$score &&
                lmin >= dmin &&
                lmax <= dmax
            ) {
              best <- list(
                lmin = lmin,
                lmax = lmax,
                lstep = lstep,
                score = score
              )
            }
          }
          z <- z + 1
        }
        k <- k + 1
      }
    }
    j <- j + 1
  }
  breaks <- seq(from = best$lmin, to = best$lmax, by = best$lstep)
  if (length(breaks) >= 2) {
    breaks[1] <- dmin
    breaks[length(breaks)] <- dmax
  }
  breaks
}

#' @rdname range_breaks
#' @param ... Other arguments passed to `extended_range_breaks_()`.
#' @export
extended_range_breaks <- function(n = 5, ...) {
  function(x) {
    extended_range_breaks_(min(x), max(x), n, ...)
  }
}

# from scales package
zero_range <- function(x, tol = 1000 * .Machine$double.eps) {
  if (length(x) == 1) {
    return(TRUE)
  }
  if (length(x) != 2) {
    cli::cli_abort("{.arg x} must be length 1 or 2, not {length(x)}.")
  }
  if (any(is.na(x))) {
    return(NA)
  }
  if (x[1] == x[2]) {
    return(TRUE)
  }
  if (all(is.infinite(x))) {
    return(FALSE)
  }
  m <- min(abs(x))
  if (m == 0) {
    return(FALSE)
  }
  abs((x[1] - x[2]) / m) < tol
}

# from scales package
precision <- function(x) {
  rng <- range(x, na.rm = TRUE)
  span <- if (zero_range(rng)) {
    abs(rng[1])
  } else {
    diff(rng)
  }
  10^floor(log10(span))
}

# nolint start
#' Format numbers with automatic number of digits
#'
#' @param x A numeric vector to format.
#' @param ... Parameters passed to [base::format()].
#'
#' @references Josh O'Brien,
#'   <https://stackoverflow.com/questions/23169938/select-accuracy-to-display-additional-axis-breaks/23171858#23171858>.
#' @author Josh O'Brien, Baptiste Auguie, Jeffrey B. Arnold
#' @return A character vector.
#' `smart_digits_format()` returns a function with a single argument
#' `x`, a numeric vector, that returns a character vector.
#'
#' @example inst/examples/ex-smart_digits.R
#' @rdname smart_digits
#' @export
# nolint end
smart_digits <- function(x, ...) {
  if (length(x) == 0) {
    return(character())
  }
  accuracy <- precision(x)
  x <- round(x / accuracy) * accuracy
  format(x, ...)
}

#' @rdname smart_digits
#' @export
smart_digits_format <- function(x, ...) {
  function(x) smart_digits(x, ...)
}

# nolint end: object_name_linter

#' Label a dated axis in the Economist 2017 style
#'
#' Truncates year labels to their last two digits, keeping the first labeled
#' year and every century boundary in full: `1948 52 56 ... 96 2000 04 08`.
#' Where no century boundary is labeled, the first year of the new century is
#' in full: `1970 90 2010`.
#' This is the convention on every dated axis in *The Economist visual
#' styleguide* (v1.2, 4 May 2017) -- see pp.6, 7, 13, 15, 16 and 23 -- and it
#' keeps a crowded time axis readable without losing the reader's anchor.
#'
#' Values that are not whole years are left in full rather than truncated,
#' since a two-digit form would be misleading for them.
#'
#' @param x A numeric vector of years to format.
#' @param ... Passed to [format()], used for the years shown in full.
#'
#' @return `economist_2017_year()` returns a character vector.
#'   `economist_2017_year_format()` returns a function of a single argument `x`
#'   that returns a character vector, for use as a scale's `labels`.
#'
#' @examples
#' economist_2017_year(c(1948, 1952, 1956, 2000, 2004))
#'
#' @family economist 2017
#' @rdname economist_2017_year
#' @export
economist_2017_year <- function(x, ...) {
  if (length(x) == 0) {
    return(character())
  }
  out <- rep(NA_character_, length(x))
  labelled <- !is.na(x)
  whole <- labelled & x == trunc(x)

  # Full for the first labelled break and at every century boundary; ggplot2
  # passes out-of-range breaks as NA, so the first non-NA entry is the first
  # break the reader actually sees.
  full <- whole & x %% 100 == 0
  first <- which(labelled)[1]
  if (length(first)) {
    full[first] <- TRUE
  }
  # A year in a new century is in full too when no century boundary is
  # labelled before it, so that 1970, 90, 2010 does not read 1970, 90, 10.
  century <- x %/% 100
  seen <- which(labelled)
  if (length(seen) > 1) {
    changed <- seen[-1][century[seen[-1]] != century[seen[-length(seen)]]]
    full[changed] <- full[changed] | whole[changed]
  }

  # Formatted one at a time: a shared call would pad every year to the widest
  # format in the vector, so a single fractional break would turn 2010 into
  # "2010.0".
  spelled <- labelled & (!whole | full)
  out[spelled] <- vapply(
    x[spelled],
    function(year) format(year, trim = TRUE, ...),
    character(1)
  )
  truncated <- whole & !full
  out[truncated] <- sprintf("%02d", as.integer(x[truncated] %% 100))
  out
}

#' @rdname economist_2017_year
#' @export
economist_2017_year_format <- function(...) {
  function(x) economist_2017_year(x, ...)
}
