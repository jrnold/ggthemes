## 45 degrees in radians
FORTY_FIVE <- 45 * pi / 180

##' Calculate slopes
##'
##' @param x x values
##' @param y y values
##' @param cull \code{logical}. Remove all slopes of 0 or \code{Inf}.
##'
##' @return Vector of slopes of line segments drawn between the
##' points. The vector has the attribute "lengths", with the length of
##' each segment.
##'
slopes <- function(x, y, cull=FALSE) {
    dx <- diff(x)
    dy <- diff(y)
    s <- dy / dx
    w <- sqrt(dx^2 + dy^2)
    if (cull) {
        touse <- abs(s) > 0 & abs(s) < Inf
        s <- s[touse]
        w <- s[touse]
    }
    attr(s, "lengths") <- w
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
##'
##' @references
##' Cleveland, W. S., M. E. McGill, and R. McGill. The Shape Parameter
##' of a Two-Variable Graph.  Journal of the American Statistical
##' Association, 83:289-300, 1988
##'
##' Heer, Jeffrey and Maneesh Agrawala, 2006. "Multi-Scale Banking to 45"
##' IEEE Transactions On Visualization And Computer Graphics.
##'
##' @inheritParams slopes
##' @return \code{numeric} The aspect ratio.
##'
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
##' \frac{ \sum_i \theta_i(\alpha) l_i}{\sum_i l_i} = \frac{\pi}{4} rad
##' }
##' where \deqn{l_i = 1} if unweighted, and \deqn{l_i = \sqrt{x_i^2 + y_i^2}}
##' (length of the line segment), if weighted.
##' The value of \deqn{\alpha} is found with \code{\link{nlm}}.
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
banking_ao <- function(x, y, weight=FALSE, cull=FALSE, ...) {
    s <- slopes(x, y, cull=cull)
    alpha0 <- banking_ms(x, y, cull=cull)
    if (weight) {
        w <- attr(s, "lengths")
    } else {
        w <- rep(1, length(s))
    }
    f <- function(alpha) {
        (weighted.mean(abs(atan(s / alpha)), w) - FORTY_FIVE)^2
        ##(mean(abs(atan(s / alpha))) - FORTY_FIVE)^2
    }
    nlm(f, alpha0, fscale=0, ...)$estimate
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

##' Banking by Optimizing Orientation Resolution
##'
##' The angle between line segments i and j is
##' \eqn{r_{i,j} = \|\theta_i(\alpha) - \theta_j(\alpha)\|}
##'
##' where \deqn{\theta_i(\alpha) = atan(s_i /  \alpha)} and
##' \deqn{s_i} is the slope of line segment i.
##' This function finds the  \deqn{\alpha} that maximizes
##' the sum of the angles between all pairs of line segments.
##'
##' \eqn{
##'   \max_{\alpha} \sum_i \sum_{j: j < 1} r_{i,j}
##' }
##'
##' The local optimization only includes line-segments
##' that are next to each other. Suppose there are n line
##' segments, then the local orientation orientation
##' has the following objective function.
##'
##' \eqn{
##'   \max_{\alpha} \sum_{i=2}^{n} r_{i,i-1}
##' }
##'
##' @references
##' Heer, Jeffrey and Maneesh Agrawala, 2006. "Multi-Scale Banking to 45"
##' IEEE Transactions On Visualization And Computer Graphics.
banking_gor <- function(x, y, cull=FALSE, ...) {
    alpha0 <- banking_ms(x, y, cull=cull)
    s <- slopes(x, y, cull=cull)
    f <- function(alpha) {
        theta <- atan(s / alpha)
        -1 * mean(as.numeric(dist(theta, method="manhattan")))
    }
    nlm(f, alpha0, ...)$estimate
}

banking_lor <- function(x, y, cull=FALSE, ...) {
    alpha0 <- banking_ms(x, y, cull=cull)
    s <- slopes(x, y, cull=cull)
    f <- function(alpha) {
        -1 * mean(abs(diff(atan(s / alpha))))
    }
    nlm(f, alpha0, ...)$estimate
}


