#' @title Clean ggplot theme
#'
#' @description Clean ggplot theme with no panel background, black axis lines
#'   and grey fill colour for chart elements.
#'
#' @author Konrad Zdeb \email{name.surname@@me.com}
#'
#' @param base_size
#' @param base_family
#'
#' @family themes
#' @export
#'
#' @examples
theme_clean <- function(base_size = 12,
                        base_family = "sans") {
  (theme_foundation(base_size = base_size,
                    base_family = base_family) + theme())
}
