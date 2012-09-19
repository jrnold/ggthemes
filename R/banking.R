## 45 degrees in radians
FORTY_FIVE <- 45 * pi / 180

slopes <- function(x, y, cull=FALSE) {
    dx <- diff(x)
    dy <- diff(y)
    s <- dx / dy
    attr(s, "lengths") <- sqrt(dx^2 + dy^2)
    if (cull) {
        touse <- abs(s) > 0 & abs(s) < Inf
        s <- s[touse]
        attr(s, "lengths") <- sqrt(dx^2 + dy^2)[touse]
    }
    s
}

##' Median Absolute Slope Banking
##'
##' Let the aspect ratio be \deqn{\alpha = \frac{w}{h}}{alpha = w/h}.
##' then the median absolute slop banking is the
##' \deqn{\alpha}{alpha} such that,
##' \eqn{
##'   median \left| \frac{s_i}{\alpha} \right| = 1
##' }{
##'  median |s_i / alpha|
##' }
##'
##' Let \deqn{R_z = z_{max} - z_{min}} for \deqn{z = x, y},
##' and \eqn{M = median \| s_i \|}. Then,
##' \eqn{
##' \alpha = M R_x / R_y
##' }
##'
##' @references
##' Cleveland, W. S., M. E. McGill, and R. McGill. The Shape Parameter
##' of a Two-Variable Graph.  Journal of the American Statistical
##' Association, 83:289-300, 1988
##'
##' Heer, Jeffrey and Maneesh Agrawala, 2006. "Multi-Scale Banking to 45"
##' IEEE Transactions On Visualization And Computer Graphics.
##'
##' @param x x-values
##' @param y y-values
##' @return \code{numeric} The aspect ratio.
banking_ms <- function(x, y, cull=FALSE) {
    s <- abs(slopes(x, y, cull=cull))
    Rx <- diff(range(x))
    Ry <- diff(range(y))
    median(s) * Rx / Ry
}

##' Average-Absolute-Orientation Banking
##'
##' Find the aspect ratio by setting the average orientation to 45
##' degrees. For aspect ratio \deqn{\alpha}{alpha}, let the
##' orientation of a line segment be \deqn{\theta_i(\alpha) = atan(s_i
##' / \alpha)}.
##'
##' \eqn{
##' \frac{1}{n} \sum_i \theta_i(\alpha) = \frac{\pi}{4} rad
##' }
##' The value of \deqn{\alpha} is found with \code{\link{uniroot}}.
##'
##' @inheritParams banking_mas
##'
##' @return \code{numeric} The aspect ratio.
##' @references
##' Cleveland, W. S. 1993. "A Model for Studying Display Methods of Statistical
##' Graphs." Journal of Computational and Statistical Graphics.
##'
##' Cleveland, W. S. 1994. The Elements of Graphing Data, Revised Edition.
##'
##' Heer, Jeffrey and Maneesh Agrawala, 2006. "Multi-Scale Banking to 45"
##' IEEE Transactions On Visualization And Computer Graphics.
banking_ao <- function(x, y, weight=FALSE, lower=0.01, upper=100, cull=FALSE, ...) {
    s <- slopes(x, y, cull=cull)
    if (weight) {
        w <- attr(s, "lengths")
    } else {
        w <- rep(1, length(s))
    }
    f <- function(alpha) {
        weighted.mean(abs(atan(s / alpha)), w) - FORTY_FIVE
        ## mean(abs(atan(s / alpha))) - FORTY_FIVE
    }
    uniroot(f, lower=lower, upper=upper, ...)$root
    #optimize(f, lower=lower, upper=upper, ...)
}

##' Average Absolute Slope Banking
##'
##' Let the aspect ratio be \deqn{\alpha = \frac{w}{h}}{alpha = w/h}.
##' then the mean absolute slope banking is the
##' \deqn{\alpha}{alpha} such that,
##' \eqn{
##'   mean \left| \frac{s_i}{\alpha} \right| = 1
##' }{
##'  mean |s_i / alpha| = 1
##' }
##'
##' Let \deqn{R_z = z_{max} - z_{min}} for \deqn{z = x, y},
##' and \eqn{M = mean \| s_i \|}. Then,
##' \eqn{
##' \alpha = M R_x / R_y
##' }
##'
##' @references
##' Heer, Jeffrey and Maneesh Agrawala, 2006. "Multi-Scale Banking to 45"
##' IEEE Transactions On Visualization And Computer Graphics.
##'
banking_as <- function(x, y, cull=FALSE) {
    s <- abs(slopes(x, y, cull=cull))
    Rx <- diff(range(x))
    Ry <- diff(range(y))
    mean(s) * Rx / Ry
}

