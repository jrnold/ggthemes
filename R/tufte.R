##' Tufte Data-Ink Maximized Theme
##'
##' Theme based on Chapter 6 "Data-Ink Maximization and Graphical
##' Design" of Edward Tufte *The Visual Display of Quantitative
##' Information*. No border, no axis lines, no grids. This theme works
##' best in combination with \code{\link{geom_rug}} or
##' \code{\link{geom_range_frame}}.
##'
##' @param ticks \code{logical} Show axis ticks?
##'
##' @references Tufte, Edward R. (2001) The Visual Display of
##' Quantitative Information, Chapter 6.
##'
##' @examples
##' # with ticks and range frames
##' (ggplot(mtcars, aes(wt, mpg))
##'  + geom_point() + geom_range_frame()
##'  + theme_tufte())
##' # with geom_rug
##' (ggplot(mtcars, aes(wt, mpg))
##'  + geom_point() + geom_rug()
##'  + theme_tufte(ticks=FALSE))
##' @export
theme_tufte <- function(ticks=TRUE) {
    ret <- theme_bw() +
        theme(panel.border = element_blank(),
              panel.background = element_rect(fill=NA, linetype=0),
              axis.line = element_blank(),
              legend.background = element_rect(fill=NA, linetype=0),
              legend.key = element_rect(fill=NA, linetype=0),
              panel.grid = element_blank(),
              plot.background = element_rect(fill="white", linetype=0))
    if (!ticks) {
        ret <- ret + theme(axis.ticks = element_blank())
    }
    ret
}

##' Range Frames
##'
##' Axis lines which show the  maximum and minimum of the data plotted.
##'
##' @section Aesthetics:
##' \code{geom_RangeFrame} understands the following aesthetics (required aesthetics are in bold):
##'
##' \itemize{
##'   \item \code{alpha}
##'   \item \code{colour}
##'   \item \code{linetype}
##'   \item \code{size}
##' }
##'
##' @inheritParams ggplot2::geom_point
##' @param sides A string that controls which sides of the plot the frames appear on.
##'   It can be set to a string containing any of \code{"trbl"}, for top, right,
##'   bottom, and left.
##' @param fun_max Function used to calculate the minimum of the range frame line.
##' @param fun_min Function used to calculate the maximum of the range frame line.
##' @export
##'
##' @references Tufte, Edward R. (2001) The Visual Display of
##' Quantitative Information, Chapter 6.
##'
##' @examples
##' (ggplot(mtcars, aes(wt, mpg))
##'  + geom_point() + geom_range_frame()
##'  + theme_tufte())
geom_range_frame <- function (mapping = NULL, data = NULL, stat = "identity", position = "identity", sides = "bl",fun_min = min, fun_max = max, ...) {
  GeomRangeFrame$new(mapping = mapping, data = data, stat = stat, position = position,
                     sides = sides,
                     fun_min = match.fun(fun_min), fun_max = match.fun(fun_max),
                     ...)
}

GeomRangeFrame <- proto(ggplot2:::Geom, {
    objname <- "rangeframe"

    draw <- function(., data, scales, coordinates, sides, fun_min, fun_max, ...) {
        rugs <- list()
        data <- coord_transform(coordinates, data, scales)
        if (!is.null(data$x)) {
            if(grepl("b", sides)) {
                rugs$x_b <- segmentsGrob(
                    x0 = unit(fun_min(data$x), "native"), x1 = unit(fun_max(data$x), "native"),
                    y0 = unit(0, "npc"), y1 = unit(0, "npc"),
                    gp = gpar(col = alpha(data$colour, data$alpha), lty = data$linetype, lwd = data$size * .pt)
                    )
            }

            if(grepl("t", sides)) {
                rugs$x_b <- segmentsGrob(
                    x0 = unit(fun_min(data$x), "native"), x1 = unit(fun_max(data$x), "native"),
                    y0 = unit(1, "npc"), y1 = unit(1, "npc"),
                    gp = gpar(col = alpha(data$colour, data$alpha), lty = data$linetype, lwd = data$size * .pt)
                    )
            }
        }

        if (!is.null(data$y)) {
            if(grepl("l", sides)) {
                rugs$y_l <- segmentsGrob(
                    y0 = unit(fun_min(data$y), "native"), y1 = unit(fun_max(data$y), "native"),
                    x0 = unit(0, "npc"), x1 = unit(0.0, "npc"),
                    gp = gpar(col = alpha(data$colour, data$alpha), lty = data$linetype, lwd = data$size * .pt)
                    )
            }

            if(grepl("r", sides)) {
                rugs$y_r <- segmentsGrob(
                    y0 = unit(fun_min(data$y), "native"), y1 = unit(fun_max(data$y), "native"),
                    x0 = unit(1, "npc"), x1 = unit(1, "npc"),
                    gp = gpar(col = alpha(data$colour, data$alpha), lty = data$linetype, lwd = data$size * .pt)
                    )
            }
        }
        gTree(children = do.call("gList", rugs))
    }

    default_stat <- function(.) StatIdentity
    default_aes <- function(.) aes(colour="black", size=0.5, linetype=1, alpha = NA)
    guide_geom <- function(.) "path"
})

#' Calculate components of five number summary
#'
#' @section Aesthetics:
#'
#' @param na.rm If \code{FALSE} (the default), removes missing values with
#'    a warning.  If \code{TRUE} silently removes missing values.
#' @inheritParams stat_identity
#' @return A data frame with additional columns:
#'   \item{width}{width of boxplot}
#'   \item{ymin}{minimum}
#'   \item{lower}{lower hinge, 25\% quantile}
#'   \item{notchlower}{lower edge of notch = median - 1.58 * IQR / sqrt(n)}
#'   \item{middle}{median, 50\% quantile}
#'   \item{notchupper}{upper edge of notch = median + 1.58 * IQR / sqrt(n)}
#'   \item{upper}{upper hinge, 75\% quantile}
#'   \item{ymax}{maximum}
#' @seealso See \code{\link{geom_boxplot}} for examples.
#' @export
#' @examples
#' # See geom_tufte_boxplot for examples
stat_fivenumber <- function (mapping = NULL, data = NULL, geom = "boxplot", position = "dodge",
na.rm = FALSE, ...) {
  StatFivenumber$new(mapping = mapping, data = data, geom = geom,
  position = position, na.rm = na.rm, ...)
}

StatFivenumber <- proto(ggplot2:::Stat, {
  objname <- "fivenumber"

  required_aes <- c("x", "y")
  default_geom <- function(.) GeomBoxplot

  calculate_groups <- function(., data, na.rm = FALSE, width = NULL, ...) {
    data <- remove_missing(data, na.rm, c("y", "weight"), name="stat_five_number",
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

##' Tufte's Box Blot
##'
##' Edward Tufte's revision of the box plot erases the box and
##' replaces it with a single middle point.
##'
##' @references Tufte, Edward R. (2001) The Visual Display of
##' Quantitative Information, Chapter 6.
##'
geom_tufteboxplot <- function (mapping = NULL, data = NULL, stat = "boxplot",
                               position = "dodge",
                               outlier.colour = "black", outlier.shape = 16,
                               outlier.size = 2, fatten=4, ...) {
    GeomTufteBoxplot$new(mapping = mapping, data = data, stat = stat,
                         position = position, outlier.colour = outlier.colour,
                         outlier.shape = outlier.shape,
                         outlier.size = outlier.size, fatten=fatten, ...)
}

GeomTufteBoxplot <- proto(ggplot2:::Geom, {
  objname <- "tufteboxplot"

  reparameterise <- function(., df, params) {
    df$width <- df$width %||%
      params$width %||% (resolution(df$x, FALSE) * 0.9)

    if (!is.null(df$outliers)) {
      suppressWarnings({
        out_min <- vapply(df$outliers, min, numeric(1))
        out_max <- vapply(df$outliers, max, numeric(1))
      })
      df$ymin_final <- pmin(out_min, df$ymin)
      df$ymax_final <- pmax(out_max, df$ymax)
    }
    df
  }

  draw <- function(., data, ..., outlier.colour = NULL,
                   outlier.shape = NULL, outlier.size = 2, fatten=4) {
    common <- data.frame(
      colour = data$colour,
      size = data$size,
      linetype = data$linetype,
      group = NA,
      stringsAsFactors = FALSE
    )

    whiskers <- data.frame(
      x = data$x,
      xend = data$x,
      y = c(data$upper, data$lower),
      yend = c(data$ymax, data$ymin),
      alpha = NA,
      common)

    if (!is.null(data$outliers) && length(data$outliers[[1]] >= 1)) {
      outliers <- data.frame(
        y = data$outliers[[1]],
        x = data$x[1],
        colour = outlier.colour %||% data$colour[1],
        shape = outlier.shape %||% data$shape[1],
        size = outlier.size %||% data$size[1],
        fill = NA,
        alpha = NA,
        stringsAsFactors = FALSE)
      outliers_grob <- GeomPoint$draw(outliers, ...)
    } else {
      outliers_grob <- NULL
    }

    ggname(.$my_name(), grobTree(
      outliers_grob,
      GeomSegment$draw(whiskers, ...),
      GeomPoint$draw(transform(data, y=middle, size=size * fatten), ...)
    ))
   }

  guide_geom <- function(.) "pointrange"
  default_stat <- function(.) StatBoxplot
  default_pos <- function(.) PositionDodge
  default_aes <- function(.) aes(colour = "black", size=0.5, linetype=1, shape=16, fill=NA, alpha = NA)
  required_aes <- c("x", "lower", "upper", "middle", "ymin", "ymax")

})

ggplot(mtcars, aes(factor(cyl), mpg)) + geom_boxplot()
ggplot(mtcars, aes(factor(cyl), mpg, colour=factor(cyl)))  + geom_tufteboxplot()
ggplot(mtcars, aes(factor(cyl), mpg, colour=factor(cyl)))  + geom_tufteboxplot(stat="fivenumber")


geom_pointrange <- function (mapping = NULL, data = NULL, stat = "identity", position = "identity", point.size=2, ...) {
  GeomPointrange$new(mapping = mapping, data = data, stat = stat, position = position, point.size=point.size, ...)
}

GeomPointrange <- proto(ggplot2:::Geom, {
  objname <- "pointrange"

  default_stat <- function(.) StatIdentity
  default_aes <- function(.) aes(colour = "black", size=0.5, linetype=1, shape=16, fill=NA, alpha = NA)
  guide_geom <- function(.) "pointrange"
  required_aes <- c("x", "y", "ymin", "ymax")

  draw <- function(., data, scales, coordinates, point.size=2, ...) {
    if (is.null(data$y)) return(GeomLinerange$draw(data, scales, coordinates, ...))
    point.size = point.size %||% data$size[1]
    ggname(.$my_name(),gTree(children=gList(
      GeomLinerange$draw(data, scales, coordinates, ...),
      GeomPoint$draw(transform(data, size = point.size), scales, coordinates, ...)
    )))
  }

  draw_legend <- function(., data, ...) {
    data <- aesdefaults(data, .$default_aes(), list(...))

    grobTree(
      GeomPath$draw_legend(data, ...),
      GeomPoint$draw_legend(transform(data, size = size * 4), ...)
    )
  }

})
