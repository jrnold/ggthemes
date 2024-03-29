% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/solarized.R
\name{theme_solarized}
\alias{theme_solarized}
\alias{theme_solarized_2}
\title{ggplot color themes based on the Solarized palette}
\usage{
theme_solarized(base_size = 12, base_family = "", light = TRUE)

theme_solarized_2(base_size = 12, base_family = "", light = TRUE)
}
\arguments{
\item{base_size}{base font size, given in pts.}

\item{base_family}{base font family}

\item{light}{\code{logical}. Light or dark theme?}
}
\description{
See \url{https://ethanschoonover.com/solarized/} for a
description of the Solarized palette.
}
\details{
Plots made with this theme integrate seamlessly with the Solarized
Beamer color theme.
\url{https://github.com/jrnold/beamercolorthemesolarized}.
There are two variations: \code{theme_solarized} is similar to
to \code{\link[ggplot2]{theme_bw}()}, while \code{theme_solarized_2()} is
similar to \code{\link[ggplot2]{theme_gray}()}.
}
\examples{
library("ggplot2")

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear)))

# Light version with different main accent colors
for (accent in names(ggthemes::ggthemes_data[["solarized"]][["accents"]])) {
  print(p + theme_solarized() +
    scale_colour_solarized(accent))
}

# Dark version
p + theme_solarized(light = FALSE) +
  scale_colour_solarized("blue")

# Alternative theme
p + theme_solarized_2(light = FALSE) +
  scale_colour_solarized("blue")
}
\concept{themes solarized}
