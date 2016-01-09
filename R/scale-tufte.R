# Much of this code is copied from the labeling package.
.simplicity <- function(q, Q, j, lmin, lmax, lstep) {
  eps <- .Machine$double.eps * 100

  n <- length(Q)
  i <- match(q, Q)[1]
  v <- ifelse( (lmin %% lstep < eps ||
                 lstep - (lmin %% lstep) < eps) &&
                lmin <= 0 && lmax >= 0, 1, 0)
  1 - (i - 1) / (n - 1) - j + v
}

.simplicity.max <- function(q, Q, j) {
  n <- length(Q)
  i <- match(q, Q)[1]
  v <- 1

  1 - (i - 1) / (n - 1) - j + v
}

.coverage <- function(dmin, dmax, lmin, lmax) {
  range <- dmax - dmin
  1 - 0.5 * ( (dmax - lmax) ^ 2 + (dmin - lmin) ^ 2) / ( (0.1 * range) ^ 2)
}

.coverage.max <- function(dmin, dmax, span) {
  range <- dmax - dmin
  if (span > range) {
    half <- (span - range) / 2
    1 - 0.5 * (half ^ 2 + half ^ 2) / ( (0.1 * range) ^ 2)
  }
  else {
    1
  }
}

.density <- function(k, m, dmin, dmax, lmin, lmax) {
  r <- (k - 1) / (lmax - lmin)
  rt <- (m - 1) / (max(lmax, dmax) - min(dmin, lmin))
  2 - max( r / rt, rt / r )
}

.density.max <- function(k, m) {
  if (k >= m)
    2 - (k - 1) / (m - 1)
  else
    1
}

.legibility <- function(lmin, lmax, lstep) {
  1      ## did all the legibility tests in C#, not in R.
}


#' Pretty axis breaks inclusive of extreme values
#'
#' This function returns pretty axis breaks that always include the extreme  values of the data.
#' This works by calling the extended Wilkinson algorithm (Talbot et. al, 2010), constrained to solutions interior to the data range.
#' Then, the minimum and maximum labels are moved to the minimum and maximum of the data range.
#'
#' \code{extended_range_breaks} implements the algorithm and returns the break values.
#' \code{scales_extended_range_breaks} uses the conventions of the \pkg{scales} package, and returns a function.
#'
#' @param dmin minimum of the data range
#' @param dmax maximum of the data range
#' @param n desired number of breaks
#' @param Q set of nice numbers
#' @param w weights applied to the four optimization components (simplicity, coverage, density, and legibility)
#' @return For \code{extended_range_breaks}, the vector of axis label locations.
#' For \code{scales_extended_range_breaks}, a function which takes a single argument, a vector of data, and returns the vector of axis label locations.
#' @references
#' Talbot, J., Lin, S., Hanrahan, P. (2010) An Extension of Wilkinson's Algorithm for Positioning Tick Labels on Axes, InfoVis 2010.
#' @author Justin Talbot \email{jtalbot@@stanford.edu}, Jeffrey B. Arnold, Baptiste Auguie
#' @rdname range_breaks
#' @export
extended_range_breaks_ <- function(dmin, dmax, n = 5,
                                   Q = c(1, 5, 2, 2.5, 4, 3),
                                   w = c(0.25, 0.2, 0.5, 0.05)) {
  eps <- .Machine$double.eps * 100

  if (dmin > dmax) {
    temp <- dmin
    dmin <- dmax
    dmax <- temp
  }

  if (dmax - dmin < eps) {
    #if the range is near the floating point limit,
    #let seq generate some equally spaced steps.
    return(seq(from = dmin, to = dmax, length.out = n))
  }

  n <- length(Q)

  best <- list()
  best$score <- -2

  j <- 1
  while (j < Inf) {
    for (q in Q) {
      sm <- .simplicity.max(q, Q, j)

      if ( (w[1] * sm + w[2] + w[3] + w[4]) < best$score) {
        j <- Inf
        break
      }

      k <- 2
      while (k < Inf) {
        dm <- .density.max(k, n)
        if ( (w[1] * sm + w[2] + w[3] * dm + w[4]) < best$score)
          break

        delta <- (dmax - dmin) / (k + 1) / j / q
        z <- ceiling(log(delta, base = 10))

        while (z < Inf) {
          step <- j * q * 10 ^ z

          cm <- .coverage.max(dmin, dmax, step * (k - 1))

          if ( (w[1] * sm + w[2] * cm + w[3] * dm + w[4]) < best$score)
            break

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

            if (score > best$score
               && lmin >= dmin
               && lmax <= dmax) {
                best <- list(lmin = lmin,
                             lmax = lmax,
                             lstep = lstep,
                             score = score)
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
#' @param ... other arguments passed to \code{extended_range_breaks_}
#' @return A function which returns breaks given a vector.
#' @export
extended_range_breaks <- function(n = 5, ...)  {
    function(x) {
        extended_range_breaks_(min(x), max(x), n, ...)
    }
}

# from scales package
zero_range <- function(x, tol = 1000 * .Machine$double.eps) {
  if (length(x) == 1)
    return(TRUE)
  if (length(x) != 2)
    stop("x must be length 1 or 2")
  if (any(is.na(x)))
    return(NA)
  if (x[1] == x[2])
    return(TRUE)
  if (all(is.infinite(x)))
    return(FALSE)
  m <- min(abs(x))
  if (m == 0)
    return(FALSE)
  abs( (x[1] - x[2]) / m) < tol
}

# from scales package
precision <- function(x) {
  rng <- range(x, na.rm = TRUE)
  span <- if (zero_range(rng))
    abs(rng[1])
  else diff(rng)
  10 ^ floor(log10(span))
}

#' Format numbers with automatic number of digits
#'
#' @param x A numeric vector to format
#' @param ... Parameters passed to \code{\link{format}}
#'
#' @references Josh O'Brien, \url{http://stackoverflow.com/questions/23169938/select-accuracy-to-display-additional-axis-breaks/23171858#23171858}.
#' @author Josh O'Brien, Baptise Auguie, Jeffrey B. Arnold
#' @return \code{smart_digits} returns a character vector.
#' \code{smart_digits_format} returns a function with a single argument \code{x}, a numeric vector, that returns a charactger vector.
#'
#' @rdname smart_digits
#' @export
smart_digits <- function(x, ...) {
  if (length(x) == 0)
    return(character())
  accuracy <- precision(x)
  x <- round(x / accuracy) * accuracy
  format(x, ...)
}

#' @rdname smart_digits
#' @export
smart_digits_format <- function(x, ...) {
    function(x) smart_digits(x, ...)
}
