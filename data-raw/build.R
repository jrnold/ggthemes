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
}
