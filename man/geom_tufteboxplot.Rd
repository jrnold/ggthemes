\name{geom_tufteboxplot}
\alias{geom_tufteboxplot}
\title{Tufte's Box Blot}
\usage{
geom_tufteboxplot(mapping = NULL, data = NULL, stat = "boxplot",
  position = "dodge", outlier.colour = "black", outlier.shape = 16,
  outlier.size = 2, fatten = 4, usebox = FALSE, boxwidth = 0.25, ...)
}
\arguments{
  \item{outlier.colour}{colour for outlying points}

  \item{outlier.shape}{shape of outlying points}

  \item{outlier.size}{size of outlying points}

  \item{fatten}{a multiplicative factor to fatten the
  middle point (or line) by}

  \item{usebox}{use a box to represent the standard error
  of the median; the same thing as the notch does in a
  standard boxplot.}

  \item{boxwidth}{a number between 0 and 1 which represents
  the relative width of the box to the middle line.}

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
Edward Tufte's revision of the box plot erases the box and
replaces it with a single point and the whiskers.
}
\section{Aesthetics}{
  \Sexpr[results=rd,stage=build]{ggthemes:::rd_aesthetics("geom_tufteboxplot",
  ggthemes:::GeomTufteboxplot)}
}
\examples{
p <- ggplot(mtcars, aes(factor(cyl), mpg))
## with only a point
p + geom_tufteboxplot()
## with a middle box
p + geom_tufteboxplot(usebox=TRUE, fatten=1)
}
\references{
Tufte, Edward R. (2001) The Visual Display of Quantitative
Information, Chapter 6.

McGill, R., Tukey, J. W. and Larsen, W. A. (1978)
Variations of box plots. The American Statistician 32,
12-16.
}
\seealso{
\code{\link{geom_boxplot}}

Other geom tufte: \code{\link{geom_rangeframe}}
}

