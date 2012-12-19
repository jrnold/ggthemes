\name{scale_colour_few}
\alias{scale_color_few}
\alias{scale_colour_few}
\alias{scale_fill_few}
\title{Few "Practical Rules for Using Color in Charts" color scales}
\usage{
  scale_colour_few(palette = "medium", ...)

  scale_color_few(palette = "medium", ...)

  scale_fill_few(palette = "light", ...)
}
\arguments{
  \item{...}{Other arguments passed on to
  \code{\link{discrete_scale}} to control name, limits,
  breaks, labels and so forth.}

  \item{palette}{One of "medium", "dark", or "light"}
}
\description{
  Qualitative color scales from Stephen Few,
  \href{http://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf}{"Practical
  Rules for Using Color in Charts"}.
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
(qplot(carat, price, data=dsamp, colour=clarity)
+ theme_few()
+ scale_colour_few())
(qplot(carat, price, data=dsamp, colour=clarity)
+ theme_few()
+ scale_colour_few("dark"))
(ggplot(diamonds, aes(clarity, fill=cut))
+ geom_bar()
+ theme_few()
+ scale_fill_few("light"))
}
\seealso{
  Other colour few: \code{\link{few_pal}}
}

