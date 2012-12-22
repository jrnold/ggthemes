\name{scale_fill_excel}
\alias{scale_color_excel}
\alias{scale_colour_excel}
\alias{scale_fill_excel}
\title{Excel color scales}
\usage{
  scale_fill_excel(palette = "line", ...)

  scale_colour_excel(palette = "fill", ...)

  scale_color_excel(palette = "fill", ...)
}
\arguments{
  \item{palette}{One of "old", "fill", or "new".}

  \item{...}{Other arguments passed on to
  \code{\link{discrete_scale}} to control name, limits,
  breaks, labels and so forth.}
}
\description{
  Excel color scales
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
(qplot(carat, price, data=dsamp, colour=clarity)
 + theme_igray()
 + scale_colour_excel("new"))
}
\seealso{
  See \code{\link{theme_excel}} for examples.

  Other colour scales: \code{\link{scale_color_solarized}},
  \code{\link{scale_colour_solarized}},
  \code{\link{scale_fill_solarized}}
}

