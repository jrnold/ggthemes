#' Calculate components of a five-number summary
#'
#' The five number summary of a sample is the minimum, first quartile,
#' median, third quartile, and maximum.
#'
#' @param na.rm If \code{FALSE} (the default), removes missing values with
#'    a warning.  If \code{TRUE} silently removes missing values.
#' @param probs Quantiles to use for the five number summary.
#' @inheritParams ggplot2::stat_identity
#' @return A data frame with additional columns:
#'   \item{width}{width of boxplot}
#'   \item{min}{minimum}
#'   \item{lower}{lower hinge, 25\% quantile}
#'   \item{middle}{median, 50\% quantile}
#'   \item{upper}{upper hinge, 75\% quantile}
#'   \item{max}{maximum}
#' @seealso \code{\link[ggplot2]{stat_boxplot}()}
#' @export
stat_fivenumber <- function(mapping = NULL,
                            data = NULL,
                            geom = "boxplot",
                            probs = c(0, 0.25, 0.5, 0.75, 1),
                            na.rm = FALSE,
                            position = "identity",
                            show.legend = NA,
                            inherit.aes = TRUE,
                            ...) {
  layer(
    data = data,
    mapping = mapping,
    stat = StatFivenumber,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      probs = probs,
      na.rm = na.rm,
      ...
    )
  )
}

# From ggplot2:::NO_GROUP
NO_GROUP <- -1

# Copied from ggplot2:::has_groups
has_groups <- function(data) {
  data$group[1L] != NO_GROUP
}

#' @export
#' @format NULL
#' @usage NULL
#' @rdname stat_fivenumber
#' @importFrom ggplot2 resolution remove_missing
StatFivenumber <- ggplot2::ggproto("StatFivenumber", ggplot2::Stat,
  required_aes = "y",

  non_missing_aes = "weight",

  setup_data = function(data, params) {
    data$x <- data$x %||% 0
    data <- remove_missing(
      data,
      na.rm = FALSE,
      vars = "x",
      name = "stat_fivenumber"
    )
    data
  },

  setup_params = function(data, params) {
    params$width <- params$width %||% (resolution(data$x %||% 0) * 0.75)

    if (is.double(data$x) && !has_groups(data) && any(data$x != data$x[1L])) {
      warning(
        "Continuous x aesthetic -- did you forget aes(group=...)?",
        call. = FALSE)
    }

    params
  },

  compute_group = function(data,
                           scales,
                           width = NULL,
                           na.rm = FALSE,
                           probs = c(0, 0.25, 0.5, 0.75, 1)) {

    if (length(probs) != 5) {
      stop("'probs' should contain 5 quantiles.")
    }
    probs <- sort(probs)
    if (!is.null(data$weight)) {
      if (!requireNamespace("quantreg", quietly = TRUE)) {
        stop("Package 'quantreg' is required for compute_group() with weights.")
      }
      mod <- quantreg::rq(y ~ 1, weights = weight, tau = probs,
                          data = data)
      stats <- as.numeric(stats::coef(mod))
    } else {
      stats <- as.numeric(quantile(data$y, probs = probs))
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
