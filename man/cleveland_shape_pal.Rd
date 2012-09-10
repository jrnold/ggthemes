\name{cleveland_shape_pal}
\alias{cleveland_shape_pal}
\title{Shape palette from Cleveland "Elements of Graphing Data" (discrete).}
\usage{
  cleveland_shape_pal(overlap = TRUE)
}
\arguments{
  \item{overlap}{\code{logical} Use the scale for
  overlapping points?}
}
\description{
  Shape palette from Cleveland "Elements of Graphing Data"
  (discrete).
}
\note{
  In the Elements of Graphing Data, Cleveland suggests two
  shapes palettes for scatter plots: one for overlapping
  data and one for non-overlapping data. The pattern for
  overlapping data relies on pattern discrimination, while
  the symbols for non-overlapping data varies the amount of
  fill. This palatte attempts to create these palettes.
  However, I found that these were hard to replicate. Using
  the R shapes and unicode fonts: the symbols can vary in
  size, they are dependent of the fonts used, and there
  does not exist a unicode symbol for a circle with a
  vertical line. If someone can improve this palette,
  please let me know.

  Following Tremmel (1995), I replace the cirlce with a
  vertical line with an encircled plus sign.
}
\examples{
# xoverlapping symbol palette
dsamp <- diamonds[sample(nrow(diamonds), 100), ]
(qplot(carat, price, data=dsamp, shape=cut)
+ theme_bw() + scale_shape_cleveland())
# non-overlapping symbol palette
(qplot(carat, price, data=dsamp, shape=cut)
+ theme_bw() + scale_shape_cleveland(overlap=FALSE))
}
\references{
  Cleveland WS. The Elements of Graphing Data. Revised
  Edition. Hobart Press, Summit, NJ, 1994, pp. 154-164,
  234-239.

  Tremmel, Lothar, (1995) "The Visual Separability of
  Plotting Symbols in Scatterplots" Journal of
  Computational and Graphical Statistics,
  \url{http://www.jstor.org/stable/1390760}
}

