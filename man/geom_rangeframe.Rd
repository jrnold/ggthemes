\name{geom_rangeframe}
\alias{geom_rangeframe}
\title{Range Frames}
\usage{
geom_rangeframe(mapping = NULL, data = NULL, stat = "identity",
  position = "identity", sides = "bl", fun_min = min, fun_max = max,
  ...)
}
\arguments{
  \item{sides}{A string that controls which sides of the
  plot the frames appear on.  It can be set to a string
  containing any of \code{"trbl"}, for top, right, bottom,
  and left.}

  \item{fun_max}{Function used to calculate the minimum of
  the range frame line.}

  \item{fun_min}{Function used to calculate the maximum of
  the range frame line.}

  \item{mapping}{The aesthetic mapping, usually constructed
  with \code{\link{aes}} or \code{\link{aes_string}}. Only
  needs to be set at the layer level if you are overriding
  the plot defaults.}

  \item{data}{A layer specific dataset - only needed if you
  want to override the plot defaults.}

  \item{stat}{The statistical transformation to use on the
  data for this layer.}

  \item{position}{The position adjustment to use for
  overlappling points on this layer}

  \item{...}{other arguments passed on to
  \code{\link{layer}}. This can include aesthetics whose
  values you want to set, not map. See \code{\link{layer}}
  for more details.}
}
\description{
Axis lines which extend to the maximum and minimum of the
plotted data.
}
\section{Aesthetics}{
  \Sexpr[results=rd,stage=build]{ggthemes:::rd_aesthetics("geom_tufteboxplot",
  ggthemes:::GeomRangeFrame)}
}
\examples{
(ggplot(mtcars, aes(wt, mpg))
 + geom_point() + geom_rangeframe()
 + theme_tufte())
}
\references{
Tufte, Edward R. (2001) The Visual Display of Quantitative
Information, Chapter 6.
}
\seealso{
Other geom tufte: \code{\link{geom_tufteboxplot}}
}

