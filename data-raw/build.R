suppressPackageStartupMessages({
  library("tidyverse")
  library("rlang")
})

GGTHEMES <- new_environment()

load_stata <- function() {
  out <- yaml::yaml.load_file(here::here("data-raw", "theme-data", "stata.yml"))
  out$colornames <- map_dfr(out$colornames, as_tibble)

  for (i in names(out$schemes)) {
    out$schemes[[i]]  <-
      tibble(name = out$schemes[[i]]) %>%
      left_join(out$colornames, by = "name")
  }
  out
}
GGTHEMES$stata <- load_stata()

load_economist <- function() {
  out <- yaml::yaml.load_file(here::here("data-raw", "theme-data",
                                         "economist.yml"))
  map(out, ~ map_dfr(., as_tibble))
}

GGTHEMES$economist <- load_economist()

load_few <- function() {
  out <- yaml::yaml.load_file(here::here("data-raw", "theme-data", "few.yml"))
  out$colors <- map(out$colors, ~ map_dfr(., as_tibble))
  out$shapes <- map_dfr(out$shapes, as_tibble)
  out
}
GGTHEMES$few <- load_few()

load_wsj <- function() {
  out <- yaml::yaml.load_file(here::here("data-raw", "theme-data", "wsj.yml"))
  out$bg <- set_names(map_chr(out$bg, "value"), map_chr(out$bg, "name"))
  out$palettes <- map(out$palettes, ~ map_dfr(., as_tibble))
  out
}
GGTHEMES$wsj <- load_wsj()

devtools::use_data(GGTHEMES, overwrite = TRUE)
