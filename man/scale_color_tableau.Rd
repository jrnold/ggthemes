\name{scale_colour_tableau}
\alias{scale_color_tableau}
\alias{scale_colour_tableau}
\alias{scale_fill_tableau}
\title{Tableau color scales.}
\usage{
  scale_colour_tableau(palette = "tableau10", ...)

  scale_fill_tableau(palette = "tableau10", ...)

  scale_color_tableau(palette = "tableau10", ...)
}
\arguments{
  \item{...}{Other arguments passed on to
  \code{\link{discrete_scale}} to control name, limits,
  breaks, labels and so forth.}

  \item{palette}{Palette name}
}
\description{
  Color scales used by
  \href{http://www.tableausoftware.com/}{Trableau}.
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
p <- qplot(carat, price, data=dsamp, colour=clarity) + theme_igray()
p + scale_colour_tableau()
p + scale_colour_tableau("tableau20")
p + scale_colour_tableau("tableau10medium")
p + scale_colour_tableau("tableau10light")
p + scale_colour_tableau("colorblind10")
p + scale_colour_tableau("trafficlight")
p + scale_colour_tableau("purplegray12")
p + scale_colour_tableau("bluered12")
p + scale_colour_tableau("greenorange12")
}
\seealso{
  \code{\link{tableau_color_pal}} for references.

  Other colour scales: \code{\link{scale_color_economist}},
  \code{\link{scale_color_excel10}},
  \code{\link{scale_color_excel2003}},
  \code{\link{scale_color_few}},
  \code{\link{scale_color_solarized}},
  \code{\link{scale_colour_economist}},
  \code{\link{scale_colour_excel10}},
  \code{\link{scale_colour_excel2003}},
  \code{\link{scale_colour_few}},
  \code{\link{scale_colour_solarized}},
  \code{\link{scale_fill_economist}},
  \code{\link{scale_fill_excel10}},
  \code{\link{scale_fill_excel2003}},
  \code{\link{scale_fill_few}},
  \code{\link{scale_fill_solarized}}
}

