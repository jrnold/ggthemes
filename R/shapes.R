##' Shape palette from Cleveland "Elements of Graphing Data" (discrete).
##'
##' @param overlap \code{logical} Use the scale for overlapping points?
##' @export
##'
##' @note In the Elements of Graphing Data, Cleveland suggests two
##' shapes palettes for scatter plots: one for overlapping data and
##' one for non-overlapping data. The pattern for overlapping data
##' relies on pattern discrimination, while the symbols for
##' non-overlapping data varies the amount of fill. This palatte
##' attempts to create these palettes. However, I found that these
##' were hard to replicate. Using the R shapes and unicode fonts: the
##' symbols can vary in size, they are dependent of the fonts used,
##' and there does not exist a unicode symbol for a circle with a
##' vertical line. If someone can improve this palette, please let me
##' know.
##'
##' @examples
##' # xoverlapping symbol palette
##' dsamp <- diamonds[sample(nrow(diamonds), 100), ]
##' (qplot(carat, price, data=dsamp, shape=cut)
##' + theme_bw() + scale_shape_cleveland())
##' # non-overlapping symbol palette
##' (qplot(carat, price, data=dsamp, shape=cut)
##' + theme_bw() + scale_shape_cleveland(overlap=FALSE))
##'
##' @references
##' Cleveland WS. The Elements of Graphing Data. Revised Edition. Hobart Press, Summit, NJ, 1994,
##' pp. 154-164, 234-239.
cleveland_shape_pal <- function(overlap=TRUE) {
    function(n) {
        maxshapes <- 5
        if (n > maxshapes) {
            msg <- sprintf(paste("The shape palette can deal with a maximum of %d discrete ",
                                 "values because more than %d becomes difficult to discriminate; ",
                                 "you have ", n, ". Consider specifying shapes manually. if you ",
                                 "must have them.", sep = ""),
                           maxshapes, maxshapes)
            warning(paste(strwrap(msg), collapse = "\n"), call. = FALSE)
        }
        if (overlap) {
        c(1, ## empty circle
          3, ## plus
          60, # <
          87, # S
          83  # W
          )[seq_len(n)]
        } else {
            c(1,
              19, ## ⚫ 26AB
              -0x25CE, ## ◎ 25CE
              -0x2609, ## ☉ 2609
              -0x25C9 ## ◉ 25C9
              )[seq_len(n)]
        }
    }
}

##' Shape scales from Cleveland "Elements of Graphing Data"
##'
##' @inheritParams ggplot2::scale_x_discrete
##' @inheritParams cleveland_shape_pal
##' @export
##'
##' @references
##' Cleveland WS. The Elements of Graphing Data. Revised Edition. Hobart Press, Summit, NJ, 1994,
##' pp. 154-164, 234-239.
##'
scale_shape_cleveland <- function(overlap=TRUE, ...) {
    discrete_scale("shape", "cleveland", cleveland_shape_pal(overlap), ...)
}

##
## Miscellaneous
## ☉ 2609
## ⚪ 26AA
## ⚫ 26AB
## Mathematical
## ⊙ 2299
## ⊚ 229A
## Geometric shapes
## ◉ 25C9
## ○ 25CB
## ◎ 25CE
## ● 25CF
## ◐ 25D0
## ◑ 25D1
## ◒ 25D2
## ◓ 25D3
## ◔ 25D4
## ◕ 25D5
## ◴ 25F4
## ◵ 25F5
## ◶ 25F6
## ◷ 25F7
## ◯ 25EF

