\name{tableau_shape_pal}
\alias{tableau_shape_pal}
\title{Tableau Shape Palettes (discrete)}
\usage{
  tableau_shape_pal(palette = "default")
}
\arguments{
  \item{palette}{Palette name:
  \Sexpr[results=rd,stage=render]{ggthemes::charopts(names(ggthemes_data$tableau$shapes))}}
}
\description{
  Shape palettes used by
  \href{http://www.tableausoftware.com/}{Tableau}.
}
\examples{
show_shapes(tableau_shape_pal()(5))
}
\seealso{
  Other shape tableau: \code{\link{scale_shape_tableau}}
}

