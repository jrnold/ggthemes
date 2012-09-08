\name{scale_fill_excel2003}
\alias{scale_color_excel2003}
\alias{scale_colour_excel2003}
\alias{scale_fill_excel2003}
\title{Excel 2003 color scales}
\usage{
  scale_fill_excel2003(fill = FALSE, ...)

  scale_colour_excel2003(fill = FALSE, ...)

  scale_color_excel2003(fill = FALSE, ...)
}
\arguments{
  \item{fill}{\code{logical} Use the fill palette?}

  \item{...}{Other arguments passed on to
  \code{\link{discrete_scale}} to control name, limits,
  breaks, labels and so forth.}
}
\description{
  Color scales from Excel 2003. For ironical purposes only.
  Supports both the fill and line palettes.
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
(d <- qplot(carat, price, data=dsamp, colour=clarity)
               + theme_economist()
               + scale_colour_economist() )
}
\seealso{
  Other colour.scales: \code{\link{scale_color_economist}},
  \code{\link{scale_color_solarized}},
  \code{\link{scale_color_stata}},
  \code{\link{scale_colour_economist}},
  \code{\link{scale_colour_solarized}},
  \code{\link{scale_colour_stata}},
  \code{\link{scale_fill_economist}},
  \code{\link{scale_fill_solarized}},
  \code{\link{scale_fill_stata}}
}

