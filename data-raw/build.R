suppressPackageStartupMessages({
  library("tidyverse")
  library("rlang")
  library("here")
  library("yaml")
})

GGTHEMES <- new_environment()

load_stata <- function() {
  out <- yaml.load_file(here("data-raw", "theme-data", "stata.yml"))
  out$colors$names <- map_dfr(out$colors$names, as_tibble)

  for (i in names(out$colors$schemes)) {
    out$colors$schemes[[i]]  <-
      tibble(name = out$colors$schemes[[i]]) %>%
      left_join(out$colors$names, by = "name")
  }
  out$shapes <- select(map_dfr(out$shapes, as_tibble), -comment)
  out
}
GGTHEMES$stata <- load_stata()

load_economist <- function() {
  out <- yaml.load_file(here("data-raw", "theme-data",
                                         "economist.yml"))
  map(out, ~ map_dfr(., as_tibble))
}

GGTHEMES$economist <- load_economist()

load_few <- function() {
  out <- yaml.load_file(here("data-raw", "theme-data", "few.yml"))
  out$colors <- map(out$colors, ~ map_dfr(., as_tibble))
  out$shapes <- map_dfr(out$shapes, as_tibble)
  out
}
GGTHEMES$few <- load_few()

load_wsj <- function() {
  out <- yaml.load_file(here("data-raw", "theme-data", "wsj.yml"))
  out$bg <- set_names(map_chr(out$bg, "value"), map_chr(out$bg, "name"))
  out$palettes <- map(out$palettes, ~ map_dfr(., as_tibble))
  out
}
GGTHEMES$wsj <- load_wsj()

load_colorblind <- function() {
  yaml.load_file(here("data-raw", "theme-data",
                                  "colorblind.yml")) %>%
    map_dfr(as_tibble)
}
GGTHEMES$colorblind <- load_colorblind()

load_ptol <- function() {
  yaml.load_file(here("data-raw", "theme-data", "pault.yml"))
}
GGTHEMES$ptol <- load_ptol()

load_manyeyes <- function() {
  yaml.load_file(here("data-raw", "theme-data", "manyeyes.yml"))
}
GGTHEMES$manyeyes <- load_manyeyes()

load_fivethirtyeight <- function() {
  yaml.load_file(here("data-raw", "theme-data", "fivethirtyeight.yml")) %>%
    map_dfr(as_tibble)
}
GGTHEMES$fivethirtyeight <- load_fivethirtyeight()

best_colors <- function(color, others = character(), n = 1) {
  solarized <- as(as(hex2RGB(ggthemes_data$solarized$accents), "LAB")@coords,
                  "matrix")
  rownames(solarized) <- names(ggthemes_data$solarized$accents)
  solarized_dist <- as.matrix(dist(solarized, method = "euclidean"))
  total_dist <- function(i) {
    sum(solarized_dist[i, i][lower.tri(diag(length(i)))])
  }
  if (n == 1) {
    colorlist <- color
  } else if (n >= length(allcolors)) {
    colorlist <- c(color, othercolors)
  } else {
    othercolors <- setdiff(allcolors, color)
    combinations <- combn(othercolors, n - 1)
    maxdist <-
      which.max(apply(combinations, 2, function(x) total_dist(c(color, x))))
    colorlist <- c(color, combinations[, maxdist])
  }
  unname(ggthemes_data$solarized$accents[colorlist])
}

tableau_palette <- function(x) {
  out <- list(name = xml_attr(x, "name"),
              type = xml_attr(x, "type"))
  out$colors <- tibble(value = map_chr(xml_children(x), xml_text))
  out
}

tableau_classic <- function() {
  classic <- read_xml(here("data-raw", "theme-data", "tableau-classic.xml"))
  map(xml_children(classic), tableau_palette)
}

load_tableau <- function() {
  tableau <- yaml.load_file(here("data-raw", "theme-data", "tableau.yml"))
  tableau[["color-palettes"]] <- map(tableau[["color-palettes"]],
      function(x) {
        map(x, ~ map_dfr(., as_tibble))
      })
  tableau[["shape-palettes"]] <- map(tableau[["shape-palettes"]], function(x) {
    map_dfr(x, as_tibble)
  })

  classic <- tableau_classic()
  for (pal in classic) {
    tableau[["color-palettes"]][[pal[["type"]]]][[pal[["name"]]]] <-
      pal[["colors"]]
  }
  tableau

}
GGTHEMES$tableau <- load_tableau()

devtools::use_data(GGTHEMES, overwrite = TRUE)

