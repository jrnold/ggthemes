\name{geom_tufteboxplot}
\alias{geom_tufteboxplot}
\title{Tufte's Box Blot}
\usage{
  geom_tufteboxplot(mapping = NULL, data = NULL,
    stat = "boxplot", position = "dodge",
    outlier.colour = "black", outlier.shape = 16,
    outlier.size = 2, fatten = 4, ...)
}
\arguments{
  \item{outlier.colour}{colour for outlying points}

  \item{outlier.shape}{shape of outlying points}

  \item{outlier.size}{size of outlying points}

  \item{fatten}{a multiplicative factor to fatten the point
  by}

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
  Edward Tufte's revision of the box plot erases the box
  and replaces it with a single middle point.
}
\section{Aesthetics}{
  \Sexpr[results=rd,stage=build]{ggplotJrnold:::rd_aesthetics("geom_tufteboxplot",
  ggplotJrnold:::GeomTufteboxplot)}
}
\examples{
p <- ggplot(mtcars, aes(factor(cyl), mpg))

p + geom_tufteboxplot()
}
\references{
  Tufte, Edward R. (2001) The Visual Display of
  Quantitative Information, Chapter 6.
}
\seealso{
  \code{\link{geom_boxplot}}
}

