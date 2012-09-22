\name{show_shapes}
\alias{show_shapes}
\title{Show shapes}
\usage{
  show_shapes(shapes)
}
\arguments{
  \item{shapes}{A numeric or character vector of shapes.
  See \code{\link{par}}.}
}
\description{
  A quick and dirty way to show shapes.
}
\examples{
library(scales)
show_shapes(shape_pal()(5))
}
\seealso{
  \code{\link[scales]{show_col}},
  \code{\link{show_linetypes}}
}

