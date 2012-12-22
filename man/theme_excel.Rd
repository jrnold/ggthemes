\name{theme_excel}
\alias{theme_excel}
\title{ggplot color theme based on old Excel plots}
\usage{
  theme_excel(horizontal = TRUE, base_size = 12,
    base_family = "")
}
\arguments{
  \item{base_size}{base font size}

  \item{base_family}{base font family}

  \item{horizontal}{\code{logical}. Horizontal axis lines?}
}
\description{
  Theme to replicate the ugly monstrosity that was the
  Excel 2003 chart. Please never use this.
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
# Old line color palette
(qplot(carat, price, data=dsamp, colour=clarity)
 + theme_excel()
 + scale_colour_excel() )
# Old fill color palette
(ggplot(diamonds, aes(clarity, fill=cut))
+ geom_bar()
+ scale_fill_excel("fill")
+ theme_excel())
}
\seealso{
  Other themes: \code{\link{theme_foundation}},
  \code{\link{theme_igray}}
}

