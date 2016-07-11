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
#' @param method One of 'ms' (Median Absolute Slope) or 'as' (Average
#' Absolute Slope). Other options are no longer supported, and will use
#' 'ms' instead with a warning.
#' @param weight No longer used, but kept for backwards compatiblity.
#' @param ... No longer used, but kept for backwards compatibility.
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
#' Heer and Agrawala (2006) and Cleveland discuss several other methods
#' including average (weighted) orientation, and global and local orientation resolution.
#' These are no longer implemented in this function. In general, either the
#' median or average absolute slopes will produce reasonable results without
#' requiring optimization.
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
#' ## Using culling
#' ## Average Absolute Slope
#' bank_slopes(x, y, method='as')
bank_slopes <- function(x, y, cull = FALSE, weight = NULL,
                        method = c("ms", "as", "ao", "gor", "lor"), ...) {
  method <- match.arg(method)
  if (method %in% c("ao", "gor", "lor")) {
    warning(sQuote("method"), " ", dQuote(method),
            " no longer supported. Using ", dQuote("ms"), " instead.")
    method <- "ms"
  }
  FUN <- bank_slopes_funs[[method]]
  # Heer produces functions with the target alpha = w/h = x/y
  xyrat <- FUN(calc_slopes(x, y, cull = cull), ...)
  # but coord_fixed ratio is the aspect ratio y/x
  1 / xyrat
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

