## 45 degrees in radians
FORTY_FIVE <- 45 * pi / 180

calc_slopes <- function(x, y, cull = FALSE) {
  dx <- diff(x)
  dy <- diff(y)
  s <- dy / dx
  w <- sqrt(dx ^ 2 + dy ^ 2)
  if (cull) {
    touse <- abs(s) > 0 & abs(s) < Inf
    s <- s[touse]
    w <- w[touse]
  }
  list(s = s, lengths = w, range_x = range(x), range_y = range(y))
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
#' @param weight \code{logical}. Weight line segments by their
#' length. Only used when \code{method='ao'}.
#' @param method One of 'ms' (Median Absolute Slope), 'as' (Average
#' Absolute Slope), 'ao' (Average Orientation), 'lor' (Local
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
#' # Use the classic sunspot data from Cleveland's orig paper
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
#' bank_slopes(x, y, method='ao', weight=TRUE)
#' bank_slopes(x, y, method='ao', cull=TRUE, weight=TRUE)
#' ## Global Orientation Resolution
#' bank_slopes(x, y, method='gor')
#' bank_slopes(x, y, method='gor', cull=TRUE)
#' ## Local Orientation Resolution
#' bank_slopes(x, y, method='lor')
#' bank_slopes(x, y, method='lor', cull=TRUE)
bank_slopes <- function(x, y, cull = FALSE, method = "ms",
                        weight = TRUE, ...) {
  FUN <- get(sprintf("bank_slopes_%s", method))
  xyrat <- FUN(calc_slopes(x, y, cull = cull), weight = weight, ...)
  1 / xyrat
}

bank_slopes_ms <- function(slopes, ...) {
  Rx <- diff(slopes$range_x)
  Ry <- diff(slopes$range_y)
  median(abs(slopes$s)) * Rx / Ry
}

bank_slopes_as <- function(slopes, ...) {
  Rx <- diff(slopes$range_x)
  Ry <- diff(slopes$range_y)
  mean(abs(slopes$s)) * Rx / Ry
}

bank_slopes_ao <- function(slopes, weight = TRUE, ...) {
  alpha0 <- bank_slopes_ms(slopes)
  if (weight) {
    f <- function(alpha, slopes) {
      (weighted.mean(abs(atan(slopes$s / alpha)),
                     slopes$length) - FORTY_FIVE) ^ 2
    }
  } else {
    f <- function(alpha, slopes) {
      (mean(abs(atan(slopes$s / alpha))) - FORTY_FIVE) ^ 2
    }
  }
  nlm(f, alpha0, slopes = slopes)$estimate
}

bank_slopes_gor <- function(slopes, ...) {
  alpha0 <- bank_slopes_ms(slopes)
  s <- slopes$s
  f <- function(alpha) {
    theta <- atan(s / alpha)
    - mean(as.numeric(dist(theta, method = "manhattan")))
  }
  nlm(f, alpha0)$estimate
}

bank_slopes_lor <- function(slopes, ...) {
  alpha0 <- bank_slopes_ms(slopes)
  s <- slopes$s
  f <- function(alpha) {
    -1 * mean(abs(diff(atan(s / alpha))))
  }
  nlm(f, alpha0)$estimate
}
