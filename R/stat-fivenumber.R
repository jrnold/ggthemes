make_fivenumber_fun <- function(fun.data,
                                fun.ymin,
                                fun.lower,
                                fun.middle,
                                fun.upper,
                                fun.ymax,
                                fun.args) {
  if (!is.null(fun.data)) {
    # Function that takes complete data frame as input
    fun.data <- match.fun(fun.data)
    function(df) {
      do.call(fun.data, c(list(quote(df$y)), fun.args))
    }
  } else {
    # Three functions that take vectors as inputs

    call_f <- function(fun, x) {
      if (is.null(fun)) return(NA_real_)
      do.call(fun, c(list(quote(x)), fun.args))
    }

    function(df, ...) {
      data.frame(
        ymin = call_f(fun.min, df$y),
        lower = call_fun(fun.lower, df$y),
        middle = call_f(fun.middle, df$y),
        upper = call_f(fun.upper, df$y),
        ymax = call_f(fun.ymax, df$y)
      )
    }
  }
}

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
#'   \item{min}{minimum}
#'   \item{lower}{lower hinge, 25\% quantile}
#'   \item{middle}{median, 50\% quantile}
#'   \item{upper}{upper hinge, 75\% quantile}
#'   \item{max}{maximum}
#' @seealso \code{\link{stat_boxplot}}
#' @export
#'
stat_fivenumber <- function(mapping = NULL,
                            data = NULL,
                            geom = "boxplot",
                            qs = c(0, 0.25, 0.5, 0.75, 1),
                            fun.args = list(),
                            na.rm = FALSE,
                            position = "identity",
                            show.legend = NA,
                            inherit.aes = TRUE,
                            ...)
  {
  layer(
    data = data,
    mapping = mapping,
    stat = StatSummaryBin,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      qs = qs,
      na.rm = na.rm,
      ...
    )
  )
}


#' @export
#' @format NULL
#' @usage NULL
#' @rdname stat_fivenumber
StatFivenumber <- ggproto("StatFivenumber", Stat,
  required_aes = c("x", "y"),

  compute_group = function(data,
                           scales,
                           width = NULL,
                           na.rm = FALSE,
                           qs = c(0, 0.25, 0.5, 0.75, 1)) {

    if (!is.null(data$weight)) {
      mod <- quantreg::rq(y ~ 1, weights = weight, tau = qunatiles,
                          data = data)
      stats <- as.numeric(stats::coef(mod))
    } else {
      stats <- as.numeric(quantile(data$y, qs))
    }
    names(stats) <- c("ymin", "lower", "middle", "upper", "ymax")
    df <- as.data.frame(as.list(stats))

    if (is.null(data$weight)) {
      n <- sum(!is.na(data$y))
    } else {
      # Sum up weights for non-NA positions of y and weight
      n <- sum(data$weight[!is.na(data$y) & !is.na(data$weight)])
    }

    df$x <- if (is.factor(data$x)) data$x[1] else mean(range(data$x))
    df$width <- width
    df$relvarwidth <- sqrt(n)
    df
  }
)
