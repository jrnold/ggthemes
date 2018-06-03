suppressPackageStartupMessages({
  library("tidyverse")
  library("rlang")
  library("here")
  library("yaml")
  library("xml2")
})



ggthemes_data <- new_environment()

load_stata <- function() {
  out <- yaml.load_file(here("data-raw", "theme-data", "stata.yml"))
  out$colors$names <- map_dfr(out$colors$names, as_tibble)

  for (i in names(out$colors$schemes)) {
    out$colors$schemes[[i]]  <-
      tibble(name = out$colors$schemes[[i]]) %>%
      left_join(out$colors$names, by = "name")
  }
  out$shapes <- select(map_dfr(out$shapes, as_tibble), -comment) %>%
    mutate(pch = utf8ToPch(character))
  out
}
ggthemes_data$stata <- load_stata()

load_economist <- function() {
  out <- yaml.load_file(here("data-raw", "theme-data",
                                         "economist.yml"))
  map(out, ~ map_dfr(., as_tibble))
}

ggthemes_data$economist <- load_economist()

load_few <- function() {
  out <- yaml.load_file(here("data-raw", "theme-data", "few.yml"))
  out$colors <- map(out$colors, ~ map_dfr(., as_tibble))
  out$shapes <- map_dfr(out$shapes, as_tibble)
  out
}
ggthemes_data$few <- load_few()

load_wsj <- function() {
  out <- yaml.load_file(here("data-raw", "theme-data", "wsj.yml"))
  out$bg <- set_names(map_chr(out$bg, "value"), map_chr(out$bg, "name"))
  out$palettes <- map(out$palettes, ~ map_dfr(., as_tibble))
  out
}
ggthemes_data$wsj <- load_wsj()

load_colorblind <- function() {
  yaml.load_file(here("data-raw", "theme-data",
                                  "colorblind.yml")) %>%
    map_dfr(as_tibble)
}
ggthemes_data$colorblind <- load_colorblind()

load_ptol <- function() {
  yaml.load_file(here("data-raw", "theme-data", "pault.yml"))
}
ggthemes_data$ptol <- load_ptol()

load_manyeyes <- function() {
  yaml.load_file(here("data-raw", "theme-data", "manyeyes.yml"))
}
ggthemes_data$manyeyes <- load_manyeyes()

load_fivethirtyeight <- function() {
  yaml.load_file(here("data-raw", "theme-data", "fivethirtyeight.yml")) %>%
    map_dfr(as_tibble)
}
ggthemes_data$fivethirtyeight <- load_fivethirtyeight()

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

utf8ToPch <- function(x) {
  # str_replace(x, "^U\\+", "") %>%
  #   as.hexmode() %>%
  #   as.integer() %>%
  #   `*`(-1)
  #   TODO: support emoji
  as.integer(-1L * map_int(x, ~ utf8ToInt(.x)[[1]]))
}

load_tableau <- function() {
  tableau <- yaml.load_file(here("data-raw", "theme-data", "tableau.yml"))
  tableau[["color-palettes"]] <- map(tableau[["color-palettes"]],
      function(x) {
        map(x, ~ map_dfr(., as_tibble))
      })
  tableau[["shape-palettes"]] <- map(tableau[["shape-palettes"]], function(x) {
    map_dfr(x, as_tibble) %>%
      mutate(pch = utf8ToPch(character))
  })

  classic <- tableau_classic()
  for (pal in classic) {
    tableau[["color-palettes"]][[pal[["type"]]]][[pal[["name"]]]] <-
      pal[["colors"]]
  }
  tableau

}
ggthemes_data$tableau <- load_tableau()

best_colors <- function(colors, accent, n = 1) {
  othercolors <- setdiff(names(colors), accent)
  solarized <- as(as(colorspace::hex2RGB(colors), "LAB")@coords, "matrix")
  solarized_dist <- as.matrix(dist(solarized, method = "euclidean"))
  total_dist <- function(i) {
    sum(solarized_dist[i, i][lower.tri(diag(length(i)))])
  }
  if (n == 1L) {
    colorlist <- accent
  } else {
    combinations <- combn(othercolors, n - 1)
    maxdist <-
      which.max(apply(combinations, 2, function(x) total_dist(c(accent, x))))
    colorlist <- c(accent, combinations[, maxdist])
  }
  unname(colors[colorlist])
}

load_solarized <- function(x) {
  out <- yaml.load_file(here("data-raw", "theme-data", "solarized.yml"))
  colors <- deframe(map_dfr(out[["Accents"]], as_tibble))
  max_n <- length(colors)
  out$palettes <- list()
  for (accent in names(colors)) {
    out$palettes[[accent]] <-
      map(seq_len(max_n), ~ best_colors(colors, accent, .))
  }
  out
}
ggthemes_data$solarized <- load_solarized()

load_excel <- function() {
  out <- yaml.load_file(here("data-raw", "theme-data", "excel.yml"))
  out$shapes <- map_dfr(out$shapes, as_tibble) %>%
    mutate(pch = utf8ToPch(character))
  out$themes <-
    yaml.load_file(here("data-raw", "theme-data", "excel-themes.yml"))
  out
}
ggthemes_data$excel <- load_excel()

load_calc <- function() {
  out <- yaml.load_file(here("data-raw", "theme-data", "libreoffice.yml")) %>%
    map(~ map_dfr(., as_tibble))
  out$shapes <- mutate(out$shapes, pch = utf8ToPch(character))
  out
}
ggthemes_data$calc <- load_calc()

load_gdocs <- function() {
  out <- yaml.load_file(here("data-raw", "theme-data", "gdocs.yml")) %>%
    map(~ map_dfr(., as_tibble))
  out$shapes <- mutate(out$shapes, pch = utf8ToPch(character))
  out
}
ggthemes_data$gdocs <- load_gdocs()

load_shapes <- function() {
  out <- yaml.load_file(here("data-raw", "theme-data", "shapes.yml"))
  out$cleveland$default <- mutate(map_dfr(out$cleveland$default, as_tibble),
                                  pch = utf8ToPch(character))
  out$cleveland$overlap <- map_dfr(out$cleveland$overlap, as_tibble)
  out$tremmel <- map(out$tremmel, ~ map_dfr(., as_tibble))
  out$circlefill <- map_df(out$circlefill, as_tibble) %>%
    mutate(pch = utf8ToPch(character))
  out
}
ggthemes_data$shapes <- load_shapes()

# save

ggthemes_data <- as.list(ggthemes_data)

devtools::use_data(ggthemes_data, overwrite = TRUE)
