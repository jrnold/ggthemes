#' Calculate components of a five-number summary
#'
#' The five number summary of a sample is the minimum, first quartile,
#' median, third quartile, and maximum.
#'
#' @param na.rm If \code{FALSE} (the default), removes missing values with
#'    a warning.  If \code{TRUE} silently removes missing values.
#' @inheritParams ggplot2::stat_identity
#' @return A data frame with additional columns:
#'   \item{width}{width of boxplot}
#'   \item{ymin}{minimum}
#'   \item{lower}{lower hinge, 25\% quantile}
#'   \item{notchlower}{lower edge of notch = median - 1.58 * IQR / sqrt(n)}
#'   \item{middle}{median, 50\% quantile}
#'   \item{notchupper}{upper edge of notch = median + 1.58 * IQR / sqrt(n)}
#'   \item{upper}{upper hinge, 75\% quantile}
#'   \item{ymax}{maximum}
#' @seealso \code{\link{stat_boxplot}}
#' @export
stat_fivenumber <- function(mapping = NULL, data = NULL, geom = "boxplot", position = "dodge", na.rm = FALSE, ..., show.legend = NA, inherit.aes = TRUE) {

  layer(
    data = data,
    mapping = mapping,
    stat = StatFivenumber,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    stat_params = list(
      na.rm = na.rm
    ),
    params = list(...)
  )
}

StatFivenumber <- ggproto("StatFivenumber", Stat,
  required_aes = c("x", "y"),

  compute_group = function(., data, scales, width = NULL, na.rm = FALSE, ...) {
    qs <- c(0, 0.25, 0.5, 0.75, 1)

    if (!is.null(data$weight)) {
      try_require("quantreg")
      stats <- as.numeric(coef(rq(y ~ 1, weights = weight, tau = qs, data = data)))
    } else {
      stats <- as.numeric(quantile(data$y, qs))
    }
    names(stats) <- c("ymin", "lower", "middle", "upper", "ymax")
    if (length(unique(data$x)) > 1)
      width <- diff(range(data$x)) * 0.9
    else
      width <- 0.9

    df <- as.data.frame(as.list(stats))
    transform(df,
      x = if (is.factor(data$x)) data$x[1] else mean(range(data$x)),
      width = width
    )
  }
)
