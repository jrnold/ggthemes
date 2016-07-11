## 45 degrees in radians
FORTY_FIVE <- base::pi / 4

calc_slopes <- function(x, y, cull = FALSE) {
  dx <- abs(diff(x))
  dy <- diff(y)
  s <- dy / dx
  touse <- if (cull) {
    abs(s) > 0 & is.finite(s)
  } else {
    is.finite(s)
  }
  list(s = s[touse],
       dx = dx[touse],
       dy = dy[touse],
       Rx = diff(range(x)),
       Ry = diff(range(y)))
}

#' Bank Slopes to 45 degrees
#'
#' Calculate the optimal aspect ratio of a line graph by banking the
#' slopes to 45 degrees as suggested by W.S. Cleveland. This
#' maximizes the ability to visually differentiate differences in
#' slope. This function will calculate the optimal aspect ratio for
#' a line plot using any of the methods described in Herr and Argwala
#' (2006). In their review of the methods they suggest using median
#' absolute slope banking ('ms'), which produces aspect ratios which
#' are generally the median of the various methods provided here.
#'
#' @param x x values
#' @param y y values
#' @param cull \code{logical}. Remove all slopes of 0 or \code{Inf}.
#' @param method One of 'ms' (Median Absolute Slope), 'as' (Average
#' Absolute Slope), 'ao' (Average Orientation), 'awo' (Average Weighted Orientation), 'lor' (Local
#' Orientation Resolution), 'gor' (Global Orientation Resolution).
#' @param ... Passed to \code{\link{nlm}} in methods 'ao', 'lor' and
#' 'gor'.
#'
#' @section Methods:
#'
#' As written, all of these methods calculate the aspect ratio (x
#' /y), but \code{bank_slopes} will return (y / x) to be compatible
#' with \code{link[ggplot2]{coord_fixed}}.
#'
#' \strong{Median Absolute Slopes Banking}
#'
#' Let the aspect ratio be \eqn{\alpha = \frac{w}{h}}{alpha = w / h}
#' then the median absolute slop banking is the
#' \eqn{\alpha}{alpha} such that,
#' \deqn{
#'   median \left| \frac{s_i}{\alpha} \right| = 1
#' }{
#'  median |s_i / alpha|
#' }
#'
#' Let \eqn{R_z = z_{max} - z_{min}}{R_z = z_max - z_min} for \eqn{z = x, y},
#' and \eqn{M = median \| s_i \|}{M = median | s_i |}. Then,
#' \deqn{
#' \alpha = M \frac{R_x}{R_y}
#' }{
#' alpha = M R_x / R_y
#' }
#'
#' \strong{Average-Absolute-Orientation Banking}
#'
#' This method finds the aspect ratio by setting the average
#' orientation to 45 degrees. For an aspect ratio
#' \eqn{\alpha}{alpha}, let the orientation of a line segment be
#' \eqn{\theta_i(\alpha) = \arctan(s_i / \alpha)}{theta_i(alpha) = atan(s_i / alpha)}.
#'
#' \deqn{
#' \frac{ \sum_i \theta_i(\alpha) l_i}{\sum_i l_i} = \frac{\pi}{4} rad
#' }{
#' ((\sum_i theta_i(alpha) l_i) / (\sum_i l_i)) = (pi / 4 ) rad
#' }
#' where \eqn{l_i = 1} if unweighted, and
#' \eqn{l_i = \sqrt{x_i^2 + y_i^2}}{l_i = sqrt(x_i^2 + y_i^2)}
#' (length of the line segment), if weighted.
#' The value of \eqn{\alpha} is found with \code{\link{nlm}}.
#'
#' \strong{Average Absolute Slope Banking}
#'
#' Let the aspect ratio be \eqn{\alpha = \frac{w}{h}}{alpha = w/h}.
#' then the mean absolute slope banking is the
#' \eqn{\alpha}{alpha} such that,
#' \deqn{
#'   mean \left| \frac{s_i}{\alpha} \right| = 1
#' }{
#'  mean |s_i / alpha| = 1
#' }
#'
#' Let \eqn{R_z = z_{max} - z_{min}} for \eqn{z = x, y},
#' and \eqn{M = mean \| s_i \|}. Then,
#' \deqn{
#' \alpha = M R_x / R_y
#' }{
#' alpha = M R_x / R_y
#' }
#'
#' \strong{Banking by Optimizing Orientation Resolution}
#'
#' The angle between line segments i and j is \eqn{r_{i, j} =
#' \|\theta_i(\alpha) - \theta_j(\alpha)\|}{r_{i, j} = |
#' theta_i(alpha) - theta_j(alpha)|}, where \eqn{\theta_i(\alpha) =
#' \arctan(s_i / \alpha)}{theta_i(alpha) = atan(s_i / \alpha)} and
#' \eqn{s_i} is the slope of line segment i. This function finds the
#' \eqn{\alpha} that maximizes the sum of the angles between all
#' pairs of line segments.
#'
#' \deqn{
#'   \max_{\alpha} \sum_i \sum_{j: j < 1} r_{i, j}
#' }{
#'   max_{alpha} sum_i sum_{j: j < 1} r_{i, j}
#' }
#'
#' The local optimization only includes line-segments
#' that are next to each other. Suppose there are n line
#' segments, then the local orientation orientation
#' has the following objective function.
#'
#' \deqn{
#'   \max_{\alpha} \sum_{i=2}^{n} r_{i, i-1}
#' }{
#'   max_{\alpha} sum_{i=2}^{n} r_{i, i-1}
#' }
#'
#' @references
#' Cleveland, W. S., M. E. McGill, and R. McGill. The Shape Parameter
#' of a Two-Variable Graph.  Journal of the American Statistical
#' Association, 83:289-300, 1988
#'
#' Heer, Jeffrey and Maneesh Agrawala, 2006. 'Multi-Scale Banking to 45'
#' IEEE Transactions On Visualization And Computer Graphics.
#'
#' Cleveland, W. S. 1993. 'A Model for Studying Display Methods of Statistical
#' Graphs.' Journal of Computational and Statistical Graphics.
#'
#' Cleveland, W. S. 1994. The Elements of Graphing Data, Revised Edition.
#'
#' @return \code{numeric} The aspect ratio (x , y).
#'
#' @seealso \code{\link[lattice]{banking}}
#' @export
#' @examples
#' library("ggplot2")
#' # Use the classic sunspot data from Cleveland's original paper
#' x <- seq_along(sunspot.year)
#' y <- as.numeric(sunspot.year)
#' # Without banking
#' m <- ggplot(data.frame(x = x, y = y), aes(x = x, y = y)) +
#'    geom_line()
#' m
#'
#' ## Using the default method, Median Absolute Slope
#' ratio <- bank_slopes(x, y)
#' m + coord_fixed(ratio = ratio)
#'
#' ## Alternative methods to calculate the banking
#' bank_slopes(x, y, method='ms')
#' ## Using culling
#' bank_slopes(x, y, method='ms', cull=TRUE)
#' ## Average Absolute Slope
#' bank_slopes(x, y, method='as')
#' bank_slopes(x, y, method='as', cull=TRUE)
#' ## Average Orientation
#' bank_slopes(x, y, method='ao')
#' bank_slopes(x, y, method='ao', cull=TRUE)
#' ## Average Orientation (Weighted)
#' bank_slopes(x, y, method='awo')
#' bank_slopes(x, y, method='awo', cull=TRUE)
#' ## Global Orientation Resolution
#' bank_slopes(x, y, method='gor')
#' bank_slopes(x, y, method='gor', cull=TRUE)
#' ## Local Orientation Resolution
#' bank_slopes(x, y, method='lor')
#' bank_slopes(x, y, method='lor', cull=TRUE)
bank_slopes <- function(x, y, cull = FALSE, method = c("ms", "as", "ao", "awo", "gor", "lor"), ...) {
  method <- match.arg(method)
  FUN <- bank_slopes_funs[[method]]
  # Heer produces functions with the target alpha = w/h = x/y
  xyrat <- FUN(calc_slopes(x, y, cull = cull), ...)
  # but coord_fixed ratio is the aspect ratio y/x
  1 / xyrat
}

calc_min_alpha <- function(slopes) {
  max(min(abs(slopes$s)) * slopes$Rx / slopes$Ry, .Machine$double.eps)
}

calc_max_alpha <- function(slopes) {
  min(max(abs(slopes$s)) * slopes$Rx / slopes$Ry, .Machine$double.xmax)
}

init_alpha <- function(slopes) {
  mean(abs(slopes$s)) * slopes$Rx / slopes$Ry
}

bank_slopes_funs <- list()

bank_slopes_funs[["ms"]] <-
    function(slopes, ...) {
      median(abs(slopes$s)) * slopes$Rx / slopes$Ry
    }

bank_slopes_funs[["as"]] <-
    function(slopes, ...) {
      mean(abs(slopes$s)) * slopes$Rx / slopes$Ry
    }

bank_slopes_funs[["ao"]] <-
  function(slopes, ...) {
    f <- function(alpha) {
      # Minimize the squared distance between average orientation and 45 degrees
      theta <- atan(slopes$s / alpha)
      mean(abs(theta)) - FORTY_FIVE
    }
    alpha_min <- calc_min_alpha(slopes)
    alpha_max <- calc_max_alpha(slopes)
    est <- uniroot(f, lower = alpha_min, upper = alpha_max, ...)
    x <- est$root
    attr(x, "optimization") <- est
    x
  }

bank_slopes_funs[["awo"]] <-
  function(slopes, ...) {
    f <- function(alpha) {
      # adjust lengths of lines for alpha
      lengths <- sqrt((slopes$dx / alpha) ^ 2 + (slopes$dy * alpha) ^ 2)
      theta <- atan(slopes$s / alpha)
      sum(abs(theta) * lengths) / sum(lengths) - FORTY_FIVE
    }
    alpha_min <- calc_min_alpha(slopes)
    alpha_max <- calc_max_alpha(slopes)
    est <- uniroot(f, lower = alpha_min, upper = alpha_max, ...)
    x <- est$root
    attr(x, "optimization") <- est
    x
  }

bank_slopes_funs[["gor"]] <-
  function(slopes, ...) {
    f <- function(alpha) {
      theta <- atan(slopes$s / alpha)
      # multiply by -1 because maximizing, not minimizing
      # manhattan distance because | theta(a)_i - theta(a)_j |
      # this only takes lower triangle, but cost function is the same as summing over all pairs
      d <- as.numeric(dist(theta, method = "manhattan"))
      mean(pmin(d, base::pi - d) ^ 2)
    }
    alpha_min <- calc_min_alpha(slopes)
    alpha_max <- calc_max_alpha(slopes)
    print(c(alpha_min, alpha_max))
    est <- optimize(f, lower = alpha_min, upper = alpha_max, maximum = TRUE, ...)
    x <- est$maximum
    attr(x, "optimization") <- est
    x
  }

bank_slopes_funs[["lor"]] <-
  function(slopes, ...) {
    f <- function(alpha) {
      theta <- atan(slopes$s / alpha)
      # multiply by -1 because maximizing, not minimizing
      d <- abs(diff(theta))
      mean(pmin(d, base::pi - d) ^ 2)
    }
    alpha_min <- calc_min_alpha(slopes)
    alpha_max <- calc_max_alpha(slopes)
    print(c(alpha_min, alpha_max))
    est <- optimize(f, lower = alpha_min, upper = alpha_max, maximum = TRUE, ...)
    x <- est$maximum
    attr(x, "optimization") <- est
    x
  }
