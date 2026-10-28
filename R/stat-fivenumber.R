#' Calculate components of a five-number summary
#'
#' The five number summary of a sample is the minimum, first quartile,
#' median, third quartile, and maximum.
#'
#' @param na.rm If `FALSE` (the default), removes missing values with
#'    a warning.  If `TRUE` silently removes missing values.
#' @param probs Quantiles to use for the five number summary.
#' @param orientation The orientation of the layer. The default (`NA`)
#'   infers it from the aesthetics: a discrete `y` with a continuous `x`
#'   summarises `x` for each level of `y`. Set it to `"x"` or `"y"` when
#'   inference fails.
#' @inheritParams ggplot2::stat_identity
#' @returns A data frame with additional columns:
#'   - `width`: width of the box plot.
#'   - `ymin`: minimum.
#'   - `lower`: lower hinge, the 25% quantile.
#'   - `middle`: median, the 50% quantile.
#'   - `upper`: upper hinge, the 75% quantile.
#'   - `ymax`: maximum.
#'   - `flipped_aes`: whether the summary is of `x` rather than `y`; if so,
#'     `ymin` and `ymax` are named `xmin` and `xmax`.
#' @seealso [ggplot2::stat_boxplot()]
#' @export
#' @example inst/examples/ex-stat_fivenumber.R
stat_fivenumber <- function(
  mapping = NULL,
  data = NULL,
  geom = "boxplot",
  probs = c(0, 0.25, 0.5, 0.75, 1),
  na.rm = FALSE, # nolint: object_name_linter
  position = "identity",
  show.legend = NA, # nolint: object_name_linter
  inherit.aes = TRUE, # nolint: object_name_linter
  ...,
  orientation = NA
) {
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
      orientation = orientation,
      ...
    )
  )
}

# From ggplot2:::NO_GROUP
NO_GROUP <- -1 # nolint: object_name_linter

# Copied from ggplot2:::has_groups
has_groups <- function(data) {
  data$group[1L] != NO_GROUP
}

# nolint start: object_name_linter
#' @export
#' @format NULL
#' @usage NULL
#' @rdname stat_fivenumber
#' @importFrom ggplot2 resolution remove_missing
#' @importFrom rlang check_installed
StatFivenumber <- ggplot2::ggproto(
  # nolint
  "StatFivenumber",
  ggplot2::Stat, # nolint: object_name_linter
  required_aes = "y|x",
  non_missing_aes = "weight",
  dropped_aes = c("x", "y", "weight"),
  extra_params = c("na.rm", "orientation"),
  # Orientation follows ggplot2::StatBoxplot: summarise the continuous axis
  # within each value of the other.
  setup_params = function(data, params) {
    params$flipped_aes <- ggplot2::has_flipped_aes(
      data,
      params,
      main_is_orthogonal = TRUE,
      group_has_equal = TRUE,
      main_is_optional = TRUE
    )
    data <- ggplot2::flip_data(data, params$flipped_aes)
    params$width <- params$width %||% (resolution(data$x %||% 0, discrete = TRUE) * 0.75)

    if (!inherits(data$x, "mapped_discrete") && is.double(data$x) && !has_groups(data) && any(data$x != data$x[1L])) {
      cli::cli_warn(c(
        "Continuous {.field {if (params$flipped_aes) 'y' else 'x'}} aesthetic.",
        "i" = "Did you forget {.code aes(group = ...)}?"
      ))
    }

    params
  },
  setup_data = function(data, params) {
    data <- ggplot2::flip_data(data, params$flipped_aes)
    data$x <- data$x %||% 0
    data <- remove_missing(
      data,
      na.rm = FALSE,
      vars = "x",
      name = "stat_fivenumber"
    )
    ggplot2::flip_data(data, params$flipped_aes)
  },
  compute_group = function(
    data,
    scales,
    width = NULL,
    na.rm = FALSE, # nolint: object_name_linter
    probs = c(0, 0.25, 0.5, 0.75, 1),
    flipped_aes = FALSE
  ) {
    data <- ggplot2::flip_data(data, flipped_aes)
    if (length(probs) != 5) {
      cli::cli_abort("{.arg probs} must contain 5 quantiles, not {length(probs)}.")
    }
    probs <- sort(probs)
    if (!is.null(data$weight)) {
      rlang::check_installed("quantreg", reason = "to use `compute_group()` with weights.")
      mod <- quantreg::rq(y ~ 1, weights = weight, tau = probs, data = data)
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
    df$flipped_aes <- flipped_aes
    ggplot2::flip_data(df, flipped_aes)
  }
)
# nolint end: object_name_linter
