## 45 degrees in radians
FORTY_FIVE <- base::pi / 4 # nolint: object_name_linter

calc_slopes <- function(x, y, cull = FALSE) {
  dx <- abs(diff(x))
  dy <- diff(y)
  s <- dy / dx
  touse <- if (cull) {
    abs(s) > 0 & is.finite(s)
  } else {
    is.finite(s)
  }
  list(
    s = s[touse],
    dx = dx[touse],
    dy = dy[touse],
    Rx = diff(range(x)),
    Ry = diff(range(y))
  )
}

#' Bank Slopes to 45 degrees
#'
#' Calculate the optimal aspect ratio of a line graph by banking the
#' slopes to 45 degrees as suggested by W.S. Cleveland. This
#' maximizes the ability to visually differentiate differences in
#' slope. This function will calculate the optimal aspect ratio for
#' a line plot using any of the methods described in Heer and Agrawala
#' (2006). In their review of the methods they suggest using median
#' absolute slope banking ('ms'), which produces aspect ratios which
#' are generally the median of the various methods provided here.
#'
#' @param x x values
#' @param y y values
#' @param cull \code{logical}. Remove all slopes of 0 or \code{Inf}.
#' @param method One of 'ms' (Median Absolute Slope), 'as' (Average
#' Absolute Slope), 'ao' (Average Absolute Orientation), or 'was' (Weighted
#' Average Absolute Slope).
#' @param weight No longer used, but kept for backwards compatibility.
#' @param ... No longer used, but kept for backwards compatibility.
#'
#' @section Methods:
#'
#' As written, all of these methods calculate the aspect ratio (x
#' /y), but \code{bank_slopes} will return (y / x) to be compatible
#' with \code{link[ggplot2]{coord_fixed()}}.
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
#' \strong{Average Absolute Orientation Banking}
#'
#' Rather than averaging the slopes themselves, this method averages the
#' \emph{orientation} (angle) of each segment, since perceived slope
#' differences are more closely related to angle than to the raw ratio
#' \eqn{dy/dx}{dy/dx}. Let \eqn{s'_i = s_i R_x / R_y}{s'_i = s_i * Rx / Ry}
#' be the range-normalized slopes. Then \eqn{\alpha}{alpha} is chosen such
#' that,
#' \deqn{
#'   mean \left| \arctan \left( \frac{s'_i}{\alpha} \right) \right| = \frac{\pi}{4}
#' }{
#'  mean |atan(s'_i / alpha)| = pi / 4
#' }
#' This has no closed-form solution and is found numerically with
#' \code{\link[stats]{uniroot}}.
#'
#' \strong{Weighted Average Absolute Slope Banking}
#'
#' Identical to Average Absolute Slope Banking, except each segment's
#' contribution is weighted by its horizontal run, \eqn{dx_i}{dx_i}, so
#' that segments spanning more horizontal (screen) space are weighted more
#' heavily than segments that happen to be sampled more densely in
#' \eqn{x}{x}. Using \eqn{s'_i}{s'_i} as above,
#' \deqn{
#'   \alpha = \frac{\sum_i dx_i \left| s'_i \right|}{\sum_i dx_i}
#' }{
#'  alpha = sum(dx_i * |s'_i|) / sum(dx_i)
#' }
#'
#' All of these methods consider the entirety of the data at once, so they
#' accentuate local features and can obscure larger-scale trends. Heer and
#' Agrawala (2006) address this with multi-scale banking, which uses spectral
#' analysis to identify the frequency scales present in the data and banks
#' each one separately; see \code{\link{bank_slopes_multiscale}} and
#' \code{\link{bank_plot_multiscale}}.
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
#' @seealso \code{\link[lattice]{banking}()}, \code{\link{bank_plot}} to bank
#' a \code{ggplot} using its own data, and
#' \code{\link{bank_slopes_multiscale}} to bank each frequency scale in the
#' data separately.
#' @export
#' @importFrom stats median uniroot weighted.mean
#' @example inst/examples/ex-bank_slopes.R
bank_slopes <- function(x, y, cull = FALSE, weight = NULL, method = c("ms", "as", "ao", "was"), ...) {
  method <- match.arg(method)
  fun <- bank_slopes_funs[[method]]
  # Heer produces functions with the target alpha = w/h = x/y
  xyrat <- fun(calc_slopes(x, y, cull = cull), ...)
  # but coord_fixed ratio is the aspect ratio y/x
  1 / xyrat
}

#' Bank a Plot's Own Data to 45 Degrees
#'
#' A convenience wrapper around \code{\link{bank_slopes}} that extracts
#' \code{x}/\code{y} directly from an already-specified \code{ggplot}, so
#' you do not have to separately reconstruct the plotted vectors by hand.
#' It builds \code{plot} with \code{\link[ggplot2]{ggplot_build}}, computes
#' the banking ratio from one layer's fully resolved data (i.e. after
#' stats, position adjustments, and faceting have been applied), and
#' returns \code{plot + \link[ggplot2]{coord_fixed}(ratio = ...)}.
#'
#' Segments are never averaged across a group or facet panel boundary:
#' slopes are computed within each combination of \code{group} and
#' \code{PANEL} and then combined, so a line plot with multiple series (or
#' facets) is banked correctly rather than picking up spurious slopes
#' between the end of one line and the start of the next.
#'
#' Note that \code{\link[ggplot2]{coord_fixed}} applies a single ratio to
#' every panel, so faceted plots are banked using the combined data from
#' all panels rather than a ratio tailored to each one individually.
#'
#' @param plot A \code{ggplot} object.
#' @param method,cull,... Passed to \code{\link{bank_slopes}}.
#' @param layer Integer. Which layer of \code{plot} to extract \code{x}/
#' \code{y} from. Defaults to the first layer.
#'
#' @return The \code{plot}, with \code{\link[ggplot2]{coord_fixed}} added.
#' @seealso \code{\link{bank_slopes}}
#' @export
#' @examples
#' library("ggplot2")
#' x <- seq_along(sunspot.year)
#' y <- as.numeric(sunspot.year)
#' p <- ggplot(data.frame(x = x, y = y), aes(x = x, y = y)) +
#'   geom_line()
#' bank_plot(p)
bank_plot <- function(plot, method = c("ms", "as", "ao", "was"), cull = FALSE, layer = 1, ...) {
  stopifnot(ggplot2::is_ggplot(plot))
  method <- match.arg(method)
  built <- ggplot2::ggplot_build(plot)
  if (layer < 1 || layer > length(built$data)) {
    cli::cli_abort("{.arg plot} only has {length(built$data)} layer(s), but {.arg layer} = {layer}.")
  }
  data <- built$data[[layer]]
  check_bank_plot_data(data)

  splits <- split(data, interaction(data$PANEL, data$group, drop = TRUE))
  slopes <- lapply(splits, function(d) calc_slopes(d$x, d$y, cull = cull))
  combined <- list(
    s = unlist(lapply(slopes, `[[`, "s"), use.names = FALSE),
    dx = unlist(lapply(slopes, `[[`, "dx"), use.names = FALSE),
    dy = unlist(lapply(slopes, `[[`, "dy"), use.names = FALSE),
    Rx = diff(range(data$x)),
    Ry = diff(range(data$y))
  )
  xyrat <- bank_slopes_funs[[method]](combined, ...)
  plot + ggplot2::coord_fixed(ratio = 1 / xyrat)
}

check_bank_plot_data <- function(data) {
  missing <- setdiff(c("x", "y"), names(data))
  if (length(missing) > 0) {
    cli::cli_abort(c(
      "The layer data is missing required column(s): {.field {missing}}.",
      "i" = "{.fn bank_plot} needs both {.field x} and {.field y}."
    ))
  }
  invisible(data)
}

bank_slopes_funs <- list()

bank_slopes_funs[["ms"]] <-
  function(slopes, ...) {
    stats::median(abs(slopes$s)) * slopes$Rx / slopes$Ry
  }

bank_slopes_funs[["as"]] <-
  function(slopes, ...) {
    mean(abs(slopes$s)) * slopes$Rx / slopes$Ry
  }

bank_slopes_funs[["ao"]] <-
  function(slopes, ...) {
    s <- slopes$s * slopes$Rx / slopes$Ry
    if (length(s) == 0 || !all(is.finite(s))) {
      return(NaN)
    }
    f <- function(alpha) mean(abs(atan(s / alpha))) - FORTY_FIVE
    pivot <- stats::median(abs(s))
    if (pivot == 0) {
      pivot <- 1
    }
    stats::uniroot(f, interval = c(pivot / 1e6, pivot * 1e6))$root
  }

bank_slopes_funs[["was"]] <-
  function(slopes, ...) {
    s <- abs(slopes$s) * slopes$Rx / slopes$Ry
    stats::weighted.mean(s, w = slopes$dx)
  }
