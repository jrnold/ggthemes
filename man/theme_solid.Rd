\name{theme_solid}
\alias{theme_solid}
\title{Theme with nothing other than a background color}
\usage{
theme_solid(fill = NA)
}
\arguments{
  \item{fill}{Background color of the plot.}
}
\description{
Theme that removes all non-geom elements (lines, text,
etc), This theme is when only the geometric objects are
desired.
}
\examples{
(ggplot(mtcars, aes(wt, mpg))
 + geom_point()
 + theme_solid("white"))
}
\seealso{
Other themes: \code{\link{theme_foundation}};
\code{\link{theme_igray}}
}
