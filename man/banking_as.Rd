\name{banking_as}
\alias{banking_as}
\title{Average Absolute Slope Banking}
\usage{
  banking_as(x, y, cull = FALSE)
}
\description{
  Let the aspect ratio be \deqn{\alpha = \frac{w}{h}}{alpha
  = w/h}. then the mean absolute slope banking is the
  \deqn{\alpha}{alpha} such that, \eqn{ mean \left|
  \frac{s_i}{\alpha} \right| = 1 }{ mean |s_i / alpha| = 1
  }
}
\details{
  Let \deqn{R_z = z_{max} - z_{min}} for \deqn{z = x, y},
  and \eqn{M = mean \| s_i \|}. Then, \eqn{ \alpha = M R_x
  / R_y }
}
\references{
  Heer, Jeffrey and Maneesh Agrawala, 2006. "Multi-Scale
  Banking to 45" IEEE Transactions On Visualization And
  Computer Graphics.
}

