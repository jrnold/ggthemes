\name{banking_ms}
\alias{banking_ms}
\title{Median Absolute Slope Banking}
\usage{
  banking_ms(x, y, cull = FALSE)
}
\arguments{
  \item{x}{x-values}

  \item{y}{y-values}
}
\value{
  \code{numeric} The aspect ratio.
}
\description{
  Let the aspect ratio be \deqn{\alpha = \frac{w}{h}}{alpha
  = w/h}. then the median absolute slop banking is the
  \deqn{\alpha}{alpha} such that, \eqn{ median \left|
  \frac{s_i}{\alpha} \right| = 1 }{ median |s_i / alpha| }
}
\details{
  Let \deqn{R_z = z_{max} - z_{min}} for \deqn{z = x, y},
  and \eqn{M = median \| s_i \|}. Then, \eqn{ \alpha = M
  R_x / R_y }
}
\references{
  Cleveland, W. S., M. E. McGill, and R. McGill. The Shape
  Parameter of a Two-Variable Graph.  Journal of the
  American Statistical Association, 83:289-300, 1988

  Heer, Jeffrey and Maneesh Agrawala, 2006. "Multi-Scale
  Banking to 45" IEEE Transactions On Visualization And
  Computer Graphics.
}

