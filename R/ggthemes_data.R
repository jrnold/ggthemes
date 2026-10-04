#' Palette and theme data
#'
#' The \code{ggthemes} environment contains various values used in
#' themes and palettes. This is undocumented and subject to change.
#'
#' \code{ggthemes_data$stata$colors$names} spans both generations of Stata's
#' named colors: the classic set plus the \code{gs0}--\code{gs16} gray scale,
#' and the \code{stc1}--\code{stc15} colors added in Stata 18. See
#' \code{\link{stata_pal}()}.
#'
#' Colors, shapes and linetypes are stored with the theme they belong to. The
#' \href{https://jrnold.github.io/ggthemes/articles/data.html}{Package data}
#' article on the package website draws every one of them. \code{ggthemes_data}
#' contains no fonts: themes set their typefaces in code.
#'
#' @format A \code{list} object.
#' @example inst/examples/ex-ggthemes_data.R
"ggthemes_data"
