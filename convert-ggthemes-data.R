# temp script to convert ggthemes-data to yaml
library(tidyverse)
library(ggthemes)
library(rlang)

listify <- function(x) {
  if (is_atomic(x)) {
    if (any(names2(x) != "")) {
      map2(names(x), x, ~ list(name = .x,
                               value = .y))
    } else {
      as.list(x)
    }
  } else {
    map(x, listify)
  }
}

listify(ggthemes::ggthemes_data) %>%
  jsonlite::toJSON(pretty = TRUE) %>%
  cat(file = "data-raw/themes.json")

themes <- jsonlite::fromJSON("data-raw/themes.json")
