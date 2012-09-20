\name{banking_gor}
\alias{banking_gor}
\title{Banking by Optimizing Orientation Resolution}
\usage{
  banking_gor(x, y, cull = FALSE, ...)
}
\description{
  The angle between line segments i and j is \eqn{r_{i,j} =
  \|\theta_i(\alpha) - \theta_j(\alpha)\|}
}
\details{
  where \deqn{\theta_i(\alpha) = atan(s_i / \alpha)} and
  \deqn{s_i} is the slope of line segment i. This function
  finds the \deqn{\alpha} that maximizes the sum of the
  angles between all pairs of line segments.

  \eqn{ \max_{\alpha} \sum_i \sum_{j: j < 1} r_{i,j} }

  The local optimization only includes line-segments that
  are next to each other. Suppose there are n line
  segments, then the local orientation orientation has the
  following objective function.

  \eqn{ \max_{\alpha} \sum_{i=2}^{n} r_{i,i-1} }
}
\references{
  Heer, Jeffrey and Maneesh Agrawala, 2006. "Multi-Scale
  Banking to 45" IEEE Transactions On Visualization And
  Computer Graphics.
}

