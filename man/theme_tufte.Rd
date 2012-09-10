\name{theme_tufte}
\alias{theme_tufte}
\title{Tufte Data-Ink Maximized Theme}
\usage{
  theme_tufte(ticks = TRUE)
}
\arguments{
  \item{ticks}{\code{logical} Show axis ticks?}
}
\description{
  Theme based on Chapter 6 "Data-Ink Maximization and
  Graphical Design" of Edward Tufte *The Visual Display of
  Quantitative Information*. No border, no axis lines, no
  grids. This theme works best in combination with
  \code{\link{geom_rug}} or \code{\link{geom_rangeframe}}.
}
\examples{
# with ticks and range frames
(ggplot(mtcars, aes(wt, mpg))
 + geom_point() + geom_rangeframe()
 + theme_tufte())
# with geom_rug
(ggplot(mtcars, aes(wt, mpg))
 + geom_point() + geom_rug()
 + theme_tufte(ticks=FALSE))
}
\references{
  Tufte, Edward R. (2001) The Visual Display of
  Quantitative Information, Chapter 6.
}

