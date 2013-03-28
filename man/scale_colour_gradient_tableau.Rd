\name{scale_colour_gradient_tableau}
\alias{scale_colour_gradient_tableau}
\alias{scale_fill_gradient_tableau}
\title{Tableau sequential colour scale (continuous)}
\usage{
  scale_colour_gradient_tableau(palette = "Red", ...,
    space = "Lab", na.value = "grey50",
    guide = "colourbar")

  scale_fill_gradient_tableau(palette = "Red", ...,
    space = "Lab", na.value = "grey50",
    guide = "colourbar")
}
\arguments{
  \item{palette}{Palette name: One of
  \Sexpr[results=rd,stage=build]{ggthemes::charopts(names(ggthemes_data$tableau$sequential))}.}

  \item{space}{Colour space in which to calculate
  gradient.}

  \item{...}{common continuous scale parameters:
  \code{name}, \code{breaks}, \code{labels},
  \code{na.value}, \code{limits} and \code{trans}.  See
  \code{\link{continuous_scale}} for more details}
}
\description{
  Tableau sequential colour scale (continuous)
}
\examples{
dsub <- subset(diamonds, x > 5 & x < 6 & y > 5 & y < 6)
d + scale_colour_gradient_tableau("Red", limits=c(3, 4))
d + scale_colour_gradient_tableau("Blue", limits=c(3, 4))
d + scale_colour_gradient_tableau("Green", limits=c(3, 4))
}
\seealso{
  Other colour tableau: \code{\link{scale_color_tableau}},
  \code{\link{scale_colour_tableau}},
  \code{\link{scale_fill_tableau}},
  \code{\link{tableau_color_pal}},
  \code{\link{tableau_seq_gradient_pal}}
}

