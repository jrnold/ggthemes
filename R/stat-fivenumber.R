##' Calculate components of a five-number summary
##'
##' The five number summary of a sample is the minimum, first quartile,
##' median, third quartile, and maximum.
##'
##' @section Aesthetics:
##' \Sexpr[results=rd,stage=build]{ggthemes:::rd_aesthetics("stat_fivenumber", ggthemes:::StatFivenumber)}
##'
##' @param na.rm If \code{FALSE} (the default), removes missing values with
##'    a warning.  If \code{TRUE} silently removes missing values.
##' @inheritParams ggplot2::stat_identity
##' @return A data frame with additional columns:
##'   \item{width}{width of boxplot}
##'   \item{ymin}{minimum}
##'   \item{lower}{lower hinge, 25\% quantile}
##'   \item{notchlower}{lower edge of notch = median - 1.58 * IQR / sqrt(n)}
##'   \item{middle}{median, 50\% quantile}
##'   \item{notchupper}{upper edge of notch = median + 1.58 * IQR / sqrt(n)}
##'   \item{upper}{upper hinge, 75\% quantile}
##'   \item{ymax}{maximum}
##' @seealso \code{\link{stat_boxplot}}
##' @export
stat_fivenumber <- function (mapping = NULL, data = NULL,
                             geom = "boxplot", position = "dodge",
                             na.rm = FALSE, ...) {
  StatFivenumber$new(mapping = mapping, data = data, geom = geom,
  position = position, na.rm = na.rm, ...)
}

StatFivenumber <- proto(ggplot2:::Stat, {
  objname <- "fivenumber"

  required_aes <- c("x", "y")
  default_geom <- function(.) GeomBoxplot

  calculate_groups <- function(., data, na.rm = FALSE, width = NULL, ...) {
    data <- remove_missing(data, na.rm, c("y", "weight"), name="stat_fivenumber",
      finite = TRUE)
    data$weight <- data$weight %||% 1
    width <- width %||%  resolution(data$x) * 0.75

    .super$calculate_groups(., data, na.rm = na.rm, width = width, ...)
  }

  calculate <- function(., data, scales, width=NULL, na.rm = FALSE, ...) {
    with(data, {
      qs <- c(0, 0.25, 0.5, 0.75, 1)
      if (length(unique(weight)) != 1) {
        try_require("quantreg")
        stats <- as.numeric(coef(rq(y ~ 1, weights = weight, tau=qs)))
      } else {
        stats <- as.numeric(quantile(y, qs))
      }
      names(stats) <- c("ymin", "lower", "middle", "upper", "ymax")
      if (length(unique(x)) > 1) width <- diff(range(x)) * 0.9
      df <- as.data.frame(as.list(stats))
      transform(df,
        x = if (is.factor(x)) x[1] else mean(range(x)),
        width = width
      )
    })
  }
})
