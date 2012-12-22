\name{scale_fill_solarized}
\alias{scale_color_solarized}
\alias{scale_colour_solarized}
\alias{scale_fill_solarized}
\title{Solarized color scales}
\usage{
  scale_fill_solarized(accent = "blue", ...)

  scale_colour_solarized(accent = "blue", ...)

  scale_color_solarized(accent = "blue", ...)
}
\arguments{
  \item{...}{Other arguments passed on to
  \code{\link{discrete_scale}} to control name, limits,
  breaks, labels and so forth.}

  \item{accent}{\code{character} Primary accent color.}
}
\description{
  Accent color theme for Solarized. Primarily for use with
  \code{\link{theme_solarized}}.
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
(d <- qplot(carat, price, data=dsamp, colour=clarity)
               + theme_solarized()
               + scale_colour_solarized() )
}
\seealso{
  Other colour scales: \code{\link{scale_color_excel10}},
  \code{\link{scale_color_excel2003}},
  \code{\link{scale_color_few}},
  \code{\link{scale_color_tableau}},
  \code{\link{scale_colour_excel10}},
  \code{\link{scale_colour_excel2003}},
  \code{\link{scale_colour_few}},
  \code{\link{scale_colour_tableau}},
  \code{\link{scale_fill_excel10}},
  \code{\link{scale_fill_excel2003}},
  \code{\link{scale_fill_few}},
  \code{\link{scale_fill_tableau}}
}

