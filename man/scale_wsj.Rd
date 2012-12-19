\name{scale_colour_wsj}
\alias{scale_color_wsj}
\alias{scale_colour_wsj}
\alias{scale_fill_wsj}
\title{Wall Street Journal color and fill scales}
\usage{
  scale_colour_wsj(palette, ...)

  scale_color_wsj(palette, ...)

  scale_fill_wsj(palette, ...)
}
\arguments{
  \item{...}{Other arguments passed on to
  \code{\link{discrete_scale}} to control name, limits,
  breaks, labels and so forth.}

  \item{palette}{\code{character} The color palette to use.
  This must be a name in
  \code{\link[=ggthemes_data]{ggthemes_data$wsj$palettes}}.}
}
\description{
  Colour and fill scales which use the palettes in
  \code{\link{wsj_pal}} and are meant for use with
  \code{\link{theme_wsj}}.
}
\seealso{
  Other colour wsj: \code{\link{wsj_pal}}
}

