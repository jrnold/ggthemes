\name{scale_fill_excel10}
\alias{scale_color_excel10}
\alias{scale_colour_excel10}
\alias{scale_fill_excel10}
\title{Excel color scales}
\usage{
  scale_fill_excel10(...)

  scale_colour_excel10(...)

  scale_color_excel10(...)
}
\arguments{
  \item{...}{Other arguments passed on to
  \code{\link{discrete_scale}} to control name, limits,
  breaks, labels and so forth.}
}
\description{
  Color scales from recent versions of Excel. See
  \code{\link{scale_fill_excel2003}} for the classic ugly
  colors.
}
\seealso{
  dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
  (qplot(carat, price, data=dsamp, colour=clarity) +
  scale_colour_excel10() )

  Other colour scales: \code{\link{scale_color_economist}},
  \code{\link{scale_color_excel2003}},
  \code{\link{scale_color_few}},
  \code{\link{scale_color_solarized}},
  \code{\link{scale_color_stata}},
  \code{\link{scale_color_tableau}},
  \code{\link{scale_colour_economist}},
  \code{\link{scale_colour_excel2003}},
  \code{\link{scale_colour_few}},
  \code{\link{scale_colour_solarized}},
  \code{\link{scale_colour_stata}},
  \code{\link{scale_colour_tableau}},
  \code{\link{scale_fill_economist}},
  \code{\link{scale_fill_excel2003}},
  \code{\link{scale_fill_few}},
  \code{\link{scale_fill_solarized}},
  \code{\link{scale_fill_stata}},
  \code{\link{scale_fill_tableau}}
}

