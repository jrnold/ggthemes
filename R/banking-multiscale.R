#' Validate a series destined for the discrete Fourier transform
#'
#' @param y candidate series.
#' @param arg,call passed to [cli::cli_abort()] for the caller's context.
#' @noRd
check_multiscale_y <- function(y, arg = rlang::caller_arg(y), call = rlang::caller_env()) {
  if (!is.numeric(y)) {
    cli::cli_abort(
      "{.arg {arg}} must be a {.cls numeric} vector, not {.cls {class(y)[[1]]}}.",
      call = call
    )
  }
  # Checked before is.finite(), which is also FALSE for NA and would otherwise
  # report the less specific message.
  if (anyNA(y)) {
    cli::cli_abort(
      c(
        "{.arg {arg}} must not contain missing values.",
        "i" = "The discrete Fourier transform is undefined in the presence of {.val {NA}}."
      ),
      call = call
    )
  }
  if (!all(is.finite(y))) {
    cli::cli_abort("{.arg {arg}} must be finite.", call = call)
  }
  if (length(y) < 4) {
    cli::cli_abort(
      c(
        "{.arg {arg}} must have at least 4 values, not {length(y)}.",
        "i" = "A shorter series has too few frequency bins to identify scales."
      ),
      call = call
    )
  }
  invisible(y)
}

#' Power spectrum of a series, excluding the DC term
#'
#' Returns the squared magnitudes of the Fourier coefficients for frequency
#' indices 1 to `floor(n / 2)`, where index `i` means "the trend repeats `i`
#' times across the series". The DC (zero-frequency) term is dropped: it
#' equals `|sum(y)|^2` and would otherwise dominate every other bin, making
#' the mean-of-spectrum threshold useless for any series with a non-zero
#' mean. The redundant conjugate half is dropped as well.
#'
#' @param y `numeric` series.
#' @return `numeric` of length `floor(length(y) / 2)`.
#' @noRd
power_spectrum <- function(y) {
  nyquist <- length(y) %/% 2
  Mod(stats::fft(y)[seq_len(nyquist) + 1])^2
}

#' Drop aspect ratios too similar to the one kept before them
#'
#' Distinct scales can bank to nearly the same aspect ratio, which would
#' produce visually redundant charts. Heer and Agrawala filter these out,
#' keeping a ratio only if it differs from its predecessor by at least a
#' scale factor (1.25 in practice).
#'
#' The comparison is symmetric -- `max / min` -- so it does not matter whether
#' ratios arrive as width/height or height/width.
#'
#' @param ar `numeric` candidate aspect ratios, in order of increasing
#'   frequency.
#' @param scale_factor `numeric` minimum ratio between successive kept values.
#' @return `numeric` the retained subset of `ar`, always including `ar[1]`.
#' @noRd
cull_ratios <- function(ar, scale_factor) {
  ar[cull_ratios_keep(ar, scale_factor)]
}

#' Which aspect ratios survive culling
#'
#' The mask behind [cull_ratios()], exposed separately so callers can carry
#' along parallel data (the frequency each ratio came from).
#'
#' Each candidate is compared against the last ratio that was *kept*, not the
#' last one considered. Comparing against the previous candidate would let a
#' run of individually-negligible steps drift arbitrarily far from the chart
#' it is nominally close to.
#'
#' @inheritParams cull_ratios
#' @return `logical` of the same length as `ar`.
#' @noRd
cull_ratios_keep <- function(ar, scale_factor) {
  keep <- rep(FALSE, length(ar))
  keep[1] <- TRUE
  last_kept <- ar[1]
  # Note this considers every remaining candidate, including the final one.
  # Algorithm 1 loops `[2 .. LENGTH(ar) - 1]` and so drops the last ratio,
  # which its own PRMTX result (2 candidates, 2 reported charts) contradicts.
  for (i in seq_along(ar)[-1]) {
    if (max(ar[i], last_kept) / min(ar[i], last_kept) > scale_factor) {
      keep[i] <- TRUE
      last_kept <- ar[i]
    }
  }
  keep
}

#' Identify scales of interest in a smoothed power spectrum
#'
#' Strong frequency components usually occupy a run of contiguous bins. Heer
#' and Agrawala retain only the last (highest-frequency) bin of each run,
#' "thereby capturing the total contribution of that local region of energy",
#' and always include the highest-frequency bin overall, which represents the
#' trend of the data in its entirety.
#'
#' @param z `numeric` smoothed power spectrum.
#' @param threshold `numeric` scalar; bins above this start a run.
#' @return `integer` frequency indices, ascending.
#' @noRd
select_scales <- function(z, threshold) {
  n <- length(z)
  i <- seq_len(n)
  # A run ends at i when z[i] is above the threshold and z[i + 1] is not.
  ends_run <- z > threshold & c(z[-1], -Inf) < threshold
  which(ends_run | i == n)
}

#' Smooth a power spectrum with a Gaussian kernel
#'
#' Heer and Agrawala convolve the power spectrum with a small Gaussian before
#' thresholding, because spectral energy tends to arrive in "clumps" that
#' contain local oscillation; smoothing evens these out so each clump is
#' detected as one run rather than several.
#'
#' At the boundaries the kernel is renormalized over the taps that fall inside
#' the series, rather than treating out-of-range values as zero. Zero-padding
#' would pull the first and last bins down and could push a genuine peak at
#' the extremes below the threshold.
#'
#' @param p `numeric` power spectrum.
#' @param window `integer` kernel width in bins.
#' @param sd `numeric` standard deviation of the kernel.
#' @return `numeric` of the same length as `p`.
#' @noRd
smooth_spectrum <- function(p, window, sd) {
  offsets <- seq_len(window) - (window %/% 2) - 1
  kernel <- stats::dnorm(offsets, mean = 0, sd = sd)
  n <- length(p)
  vapply(
    seq_len(n),
    function(i) {
      j <- i + offsets
      inside <- j >= 1 & j <= n
      sum(p[j[inside]] * kernel[inside]) / sum(kernel[inside])
    },
    numeric(1)
  )
}

#' Ideal low-pass filter in the frequency domain
#'
#' Zeroes every Fourier coefficient above `cutoff` and inverts the transform,
#' producing the trend curve for a given scale. Coefficients are dropped in
#' conjugate pairs so the result is real. The DC term is always kept -- zero
#' is not a frequency "higher than the current scale", and discarding it would
#' shift the trend off the data and change `Ry`, and so the banking.
#'
#' @param y `numeric` series.
#' @param cutoff `integer` frequency index; frequencies above this are removed.
#' @return `numeric` of the same length as `y`.
#' @noRd
lowpass <- function(y, cutoff) {
  n <- length(y)
  k <- seq_len(n)
  # Frequency of each coefficient, folding the redundant conjugate half back
  # onto its positive-frequency twin.
  freq <- pmin(k - 1, n - k + 1)
  coefs <- stats::fft(y)
  coefs[freq > cutoff] <- 0 + 0i
  Re(stats::fft(coefs, inverse = TRUE)) / n
}

#' Multi-Scale Banking to 45 Degrees
#'
#' Compute a set of aspect ratios, one per frequency scale present in a
#' series, using the multi-scale banking algorithm of Heer and Agrawala
#' (2006). Single-scale banking (\code{\link{bank_slopes}}) considers the
#' whole series at once, so it accentuates local features and can obscure
#' larger-scale trends. Multi-scale banking instead uses spectral analysis to
#' find the scales that carry real energy, low-pass filters the data to each
#' of those scales in turn, and banks the resulting trend curve, yielding one
#' aspect ratio per scale.
#'
#' @details
#'
#' The procedure is Algorithm 1 of Heer and Agrawala (2006):
#'
#' \enumerate{
#' \item Take the discrete Fourier transform of \code{y} and form the power
#'   spectrum from the squared coefficient magnitudes.
#' \item Smooth the spectrum by convolving it with a Gaussian kernel, since
#'   spectral energy tends to arrive in "clumps" containing local oscillation.
#' \item Threshold the smoothed spectrum. Contiguous runs above the threshold
#'   are collapsed to their highest-frequency bin, capturing the total
#'   contribution of that region of energy.
#' \item For each retained scale, low-pass filter \code{y} to remove all
#'   higher frequencies and bank the resulting trend curve to 45 degrees using
#'   \code{\link{bank_slopes}}.
#' \item Discard aspect ratios within \code{scale_factor} of the previous
#'   retained ratio, since they would produce visually redundant charts.
#' }
#'
#' The scale corresponding to the data in its entirety is always included.
#'
#' Because the algorithm is defined on the frequency domain of \code{y} alone,
#' it assumes observations are evenly spaced in \code{x}; the banking of each
#' trend curve uses \code{x = seq_along(y)}.
#'
#' @param y \code{numeric} series of evenly spaced observations.
#' @param method,cull Passed to \code{\link{bank_slopes}}. The defaults are
#' those Heer and Agrawala used for all results reported in their Section 3.2:
#' median absolute slope banking with slopeless line culling.
#' @param window \code{integer} width, in frequency bins, of the Gaussian
#' kernel used to smooth the power spectrum.
#' @param sd \code{numeric} standard deviation of that Gaussian kernel.
#' @param threshold \code{numeric} power above which a frequency bin counts as
#' a scale of interest. Defaults to the mean of the smoothed power spectrum.
#' Raise it to select fewer scales.
#' @param scale_factor \code{numeric} minimum ratio between successive
#' retained aspect ratios.
#'
#' @return A \code{\link[tibble]{tibble}} with one row per retained scale, in
#' ascending order of frequency, and columns:
#' \describe{
#' \item{\code{frequency}}{\code{integer} frequency index, i.e. the number of
#'   times the trend repeats across the series.}
#' \item{\code{ratio}}{\code{numeric} aspect ratio in the \code{y / x} sense
#'   used by \code{\link[ggplot2]{coord_fixed}()}.}
#' \item{\code{aspect_ratio}}{\code{numeric} the same value as width / height,
#'   the convention in which the banking literature reports aspect ratios.}
#' }
#'
#' @references
#' Heer, Jeffrey and Maneesh Agrawala, 2006. "Multi-Scale Banking to 45."
#' IEEE Transactions On Visualization And Computer Graphics 12(5).
#'
#' Cleveland, W. S. 1993. "A Model for Studying Display Methods of Statistical
#' Graphs." Journal of Computational and Statistical Graphics.
#'
#' @seealso \code{\link{bank_slopes}} for single-scale banking, and
#' \code{\link{bank_plot_multiscale}} to bank a \code{ggplot} at every scale.
#' @export
#' @importFrom stats fft dnorm
#' @example inst/examples/ex-bank_slopes_multiscale.R
bank_slopes_multiscale <- function(
  y,
  method = c("ms", "as", "ao", "was"),
  cull = TRUE,
  window = 3,
  sd = 1,
  threshold = NULL,
  scale_factor = 1.25
) {
  method <- match.arg(method)
  check_multiscale_y(y)
  z <- smooth_spectrum(power_spectrum(y), window = window, sd = sd)
  scales <- select_scales(z, threshold %||% mean(z))
  x <- seq_along(y)
  # bank_slopes() returns y / x; the paper works in x / y throughout.
  aspect <- vapply(
    scales,
    function(f) 1 / bank_slopes(x, lowpass(y, f), cull = cull, method = method),
    numeric(1)
  )
  keep <- cull_ratios_keep(aspect, scale_factor)
  tibble::tibble(
    frequency = as.integer(scales[keep]),
    ratio = 1 / aspect[keep],
    aspect_ratio = aspect[keep]
  )
}

#' Bank a Plot's Own Data at Every Scale
#'
#' A convenience wrapper around \code{\link{bank_slopes_multiscale}} that
#' extracts \code{y} directly from an already-specified \code{ggplot} and
#' returns one copy of the plot per scale of interest, each with the
#' appropriate \code{\link[ggplot2]{coord_fixed}} applied. The result is the
#' small-multiples display used throughout Heer and Agrawala (2006): the same
#' data, banked to reveal trends at different frequencies.
#'
#' Multi-scale banking is defined on the frequency domain of a single series
#' sampled on a regular grid, so unlike \code{\link{bank_plot}} this function
#' requires the chosen layer to hold exactly one series with evenly spaced
#' \code{x} values.
#'
#' @param plot A \code{ggplot} object.
#' @param layer Integer. Which layer of \code{plot} to extract \code{y} from.
#' Defaults to the first layer.
#' @param method,cull,... Passed to \code{\link{bank_slopes_multiscale}}.
#'
#' @return A named \code{list} of \code{ggplot} objects, one per retained
#' scale, in ascending order of frequency and named by frequency index.
#'
#' @references
#' Heer, Jeffrey and Maneesh Agrawala, 2006. "Multi-Scale Banking to 45."
#' IEEE Transactions On Visualization And Computer Graphics 12(5).
#'
#' @seealso \code{\link{bank_slopes_multiscale}}, \code{\link{bank_plot}}
#' @export
#' @example inst/examples/ex-bank_plot_multiscale.R
bank_plot_multiscale <- function(plot, method = c("ms", "as", "ao", "was"), cull = TRUE, layer = 1, ...) {
  stopifnot(ggplot2::is_ggplot(plot))
  method <- match.arg(method)
  built <- ggplot2::ggplot_build(plot)
  if (layer < 1 || layer > length(built$data)) {
    cli::cli_abort("{.arg plot} only has {length(built$data)} layer(s), but {.arg layer} = {layer}.")
  }
  data <- built$data[[layer]]
  check_bank_plot_data(data)
  data <- check_multiscale_series(data)

  scales <- bank_slopes_multiscale(data$y, method = method, cull = cull, ...)
  plots <- lapply(scales$ratio, function(r) plot + ggplot2::coord_fixed(ratio = r))
  names(plots) <- as.character(scales$frequency)
  plots
}

#' Check that layer data is a single, regularly sampled series
#'
#' @param data layer data from [ggplot2::ggplot_build()].
#' @return `data`, sorted by `x`.
#' @noRd
check_multiscale_series <- function(data, call = rlang::caller_env()) {
  series <- unique(interaction(data$PANEL %||% 1L, data$group %||% 1L, drop = TRUE))
  if (length(series) > 1) {
    cli::cli_abort(
      c(
        "{.fn bank_plot_multiscale} needs a single series, but the layer has {length(series)}.",
        "i" = "The discrete Fourier transform is defined on one series at a time.",
        "i" = "Use {.fn bank_plot} to bank several groups or facets with one ratio."
      ),
      call = call
    )
  }
  data <- data[order(data$x), ]
  spacing <- diff(data$x)
  if (length(spacing) > 0 && max(abs(spacing - mean(spacing))) > 1e-6 * abs(mean(spacing))) {
    cli::cli_abort(
      c(
        "{.fn bank_plot_multiscale} needs {.field x} to be evenly spaced.",
        "i" = "Multi-scale banking analyses the frequency domain of {.field y}, which assumes a regular grid.",
        "i" = "Use {.fn bank_plot} for irregularly sampled data."
      ),
      call = call
    )
  }
  data
}
