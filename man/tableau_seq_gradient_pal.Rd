\name{tableau_seq_gradient_pal}
\alias{tableau_seq_gradient_pal}
\title{Tableau sequential colour gradient palette (continuous)}
\usage{
  tableau_seq_gradient_pal(palette = "Red", space = "Lab")
}
\arguments{
  \item{palette}{Palette name: One of
  \Sexpr[results=rd,stage=build]{ggthemes::charopts(names(ggthemes_data$tableau$sequential))}.}

  \item{space}{Colour space in which to calculate
  gradient.}
}
\description{
  Tableau sequential colour gradient palette (continuous)
}
\examples{
x <- seq(0, 1, length = 25)
show_col(tableau_seq_gradient_pal("Red")(x))
show_col(tableau_seq_gradient_pal("Blue")(x))
show_col(tableau_seq_gradient_pal("Purple Sequential")(x))
}
\seealso{
  Other colour tableau: \code{\link{scale_color_tableau}},
  \code{\link{scale_colour_gradient_tableau}},
  \code{\link{scale_colour_tableau}},
  \code{\link{scale_fill_gradient_tableau}},
  \code{\link{scale_fill_tableau}},
  \code{\link{tableau_color_pal}}
}

