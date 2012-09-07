##' Shape palette from Cleveland "Elements of Graphing Data" (discrete).
##'
##' @param overlap \code{logical} Use the scale for overlapping points?
##' @export
cleveland_shape_pal <- function(overlap=TRUE) {
    function(n) {
        if (n > 5) {
            msg <- paste("The shape palette can deal with a maximum of 6 discrete ",
                         "values because more than 6 becomes difficult to discriminate; ",
                         "you have ", n, ". Consider specifying shapes manually. if you ",
                         "must have them.", sep = "")
            warning(paste(strwrap(msg), collapse = "\n"), call. = FALSE)
        }
        if (overlap) {
        c(1, 3,
          60, # <
          87, # S
          83  # W
          )[seq_len(n)]
        } else {
            c(-0x25EF, #  ◯ 25EF
              -0x25CF, #  ● 25CF
              -0x25C9 #  ◉ 25C9
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
##' Cleveland WS. The Elements of Graphing Data. Revised Edition. Hobart Press, Summit, NJ, 1994.
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

