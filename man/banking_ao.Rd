\name{banking_ao}
\alias{banking_ao}
\title{Average-Absolute-Orientation Banking}
\usage{
  banking_ao(x, y, weight = FALSE, cull = FALSE, ...)
}
\value{
  \code{numeric} The aspect ratio.
}
\description{
  Find the aspect ratio by setting the average orientation
  to 45 degrees. For aspect ratio \deqn{\alpha}{alpha}, let
  the orientation of a line segment be
  \deqn{\theta_i(\alpha) = atan(s_i / \alpha)}.
}
\details{
  \eqn{ \frac{ \sum_i \theta_i(\alpha) l_i}{\sum_i l_i} =
  \frac{\pi}{4} rad } where \deqn{l_i = 1} if unweighted,
  and \deqn{l_i = \sqrt{x_i^2 + y_i^2}} (length of the line
  segment), if weighted. The value of \deqn{\alpha} is
  found with \code{\link{nlm}}.
}
\references{
  Cleveland, W. S. 1993. "A Model for Studying Display
  Methods of Statistical Graphs." Journal of Computational
  and Statistical Graphics.

  Cleveland, W. S. 1994. The Elements of Graphing Data,
  Revised Edition.

  Heer, Jeffrey and Maneesh Agrawala, 2006. "Multi-Scale
  Banking to 45" IEEE Transactions On Visualization And
  Computer Graphics.
}

