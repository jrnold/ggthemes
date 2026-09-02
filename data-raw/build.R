suppressPackageStartupMessages({
  library("dplyr")
  library("purrr")
  library("tibble")
  library("rlang")
  library("yaml")
  library("xml2")
})

# Shape tables ---------------------------------------------------------------
#
# `shape` is the canonical shape name and the only hand-written shape field:
# both pch columns are derived from it and from `character`. The vocabulary
# lives in R/shape-names.R and is sourced rather than copied, so the build
# script and the package cannot drift apart.
source(here::here("R", "shape-names.R"))

# The codepoint a `unicode` field names. A few rows carry a variation selector
# ("U+2714 U+FE0E"), which selects a rendering of the same character rather
# than a different character, so only the first token identifies the shape.
unicode_codepoint <- function(x) {
  strtoi(sub("^U\\+", "", sub(" .*$", "", x)), base = 16L)
}

# The codepoint a `character` field actually holds. R draws a negative pch by
# asking the font for -pch, so this is the Unicode pch.
character_codepoint <- function(x) {
  map_int(x, ~ utf8ToInt(.x)[[1]])
}

# pch values R can draw without consulting a font: the symbol set 0:25 and the
# ASCII range 32:127.
SAFE_PCH <- c(0:25, 32:127) # nolint: object_name_linter

# Build one shape table, deriving `pch` (font-independent, `NA` where the shape
# has no base equivalent) and `pch_unicode` (the negative glyph pch), and
# aborting on any row where the hand-written fields disagree. Bugs that a
# reviewer would have to spot by eye -- a `pch` that does not match its own
# `name`, a `character` that does not match its own `unicode` -- become build
# failures instead.
shape_table <- function(rows, label, unicode_col = "unicode", duplicates = TRUE) {
  out <- map_dfr(rows, as_tibble)
  at <- function(i) paste0(label, "[", i, "] ")

  unknown <- which(!out[["shape"]] %in% names(shape_pch))
  if (length(unknown)) {
    abort(paste0(
      "Shape name not in the vocabulary (see R/shape-names.R):\n",
      paste0(at(unknown), encodeString(out[["shape"]][unknown], quote = '"'), collapse = "\n")
    ))
  }

  declared <- unicode_codepoint(out[[unicode_col]])
  actual <- character_codepoint(out[["character"]])
  mismatch <- which(declared != actual)
  if (length(mismatch)) {
    abort(paste0(
      "`character` does not hold the codepoint `",
      unicode_col,
      "` names:\n",
      paste0(
        at(mismatch),
        out[[unicode_col]][mismatch],
        " declared, but ",
        sprintf("U+%04X", actual[mismatch]),
        " stored",
        collapse = "\n"
      )
    ))
  }

  out[["pch"]] <- unname(shape_pch[out[["shape"]]])
  out[["pch_unicode"]] <- -actual

  unsafe <- which(!is.na(out[["pch"]]) & !out[["pch"]] %in% SAFE_PCH)
  if (length(unsafe)) {
    abort(paste0(
      "Derived pch outside 0:25 and 32:127:\n",
      paste0(at(unsafe), out[["shape"]][unsafe], " -> ", out[["pch"]][unsafe], collapse = "\n")
    ))
  }

  if (duplicates) {
    check_shape_duplicates(out, label)
  }
  out
}

# Two shapes in one palette that draw the same pch are indistinguishable. `NA`
# is exempt: it means "no font-independent equivalent", and any number of rows
# may have none.
check_shape_duplicates <- function(shapes, label) {
  pch <- shapes[["pch"]][!is.na(shapes[["pch"]])]
  dup <- unique(pch[duplicated(pch)])
  if (length(dup)) {
    abort(paste0(
      label,
      ": these shapes share a pch and would be indistinguishable:\n",
      paste0(
        "  pch ",
        dup,
        " <- ",
        map_chr(dup, ~ paste(shapes[["shape"]][which(shapes[["pch"]] == .x)], collapse = ", ")),
        collapse = "\n"
      )
    ))
  }
}

# The ten symbolstyles `stata_shape_pal()` selects from the 22-row catalogue.
# Sourced, not copied, for the same reason as the shape vocabulary above.
source(here::here("R", "stata-shapes.R"))

ggthemes_data <- new_environment()

load_stata <- function() {
  out <- yaml.load_file(here::here("data-raw", "theme-data", "stata.yml"))
  out$colors$names <- map_dfr(out$colors$names, as_tibble)

  for (i in names(out$colors$schemes)) {
    out$colors$schemes[[i]] <-
      tibble(name = out$colors$schemes[[i]]) |>
      left_join(out$colors$names, by = "name")
  }
  # The catalogue legitimately collapses `smcircle` onto the same pch as
  # `circle`: pch encodes symbol identity and delegates size to the `size`
  # aesthetic. Duplicates are therefore checked over the ten symbolstyles
  # `stata_shape_pal()` actually selects (see R/stata.R), not the whole table.
  out$shapes <- select(
    shape_table(
      out$shapes,
      "stata.yml:shapes",
      unicode_col = "unicode_value",
      duplicates = FALSE
    ),
    -comment
  )
  check_shape_duplicates(
    out$shapes[out$shapes[["symbolstyle"]] %in% stata_palette_shapes, ],
    "stata.yml:shapes (stata_shape_pal)"
  )
  out
}
ggthemes_data$stata <- load_stata()

load_economist <- function() {
  out <- yaml.load_file(here::here(
    "data-raw",
    "theme-data",
    "economist.yml"
  ))
  map(out, ~ map_dfr(., as_tibble))
}

ggthemes_data$economist <- load_economist()

load_few <- function() {
  out <- yaml.load_file(here::here("data-raw", "theme-data", "few.yml"))
  out$colors <- map(out$colors, ~ map_dfr(., as_tibble))
  out$shapes <- shape_table(out$shapes, "few.yml:shapes")
  out
}
ggthemes_data$few <- load_few()

load_wsj <- function() {
  out <- yaml.load_file(here::here("data-raw", "theme-data", "wsj.yml"))
  out$bg <- set_names(map_chr(out$bg, "value"), map_chr(out$bg, "name"))
  out$palettes <- map(out$palettes, ~ map_dfr(., as_tibble))
  out
}
ggthemes_data$wsj <- load_wsj()

load_colorblind <- function() {
  yaml.load_file(here::here(
    "data-raw",
    "theme-data",
    "colorblind.yml"
  )) |>
    map_dfr(as_tibble)
}
ggthemes_data$colorblind <- load_colorblind()

load_ptol <- function() {
  yaml.load_file(here::here("data-raw", "theme-data", "pault.yml"))
}
ggthemes_data$ptol <- load_ptol()

load_manyeyes <- function() {
  yaml.load_file(here::here("data-raw", "theme-data", "manyeyes.yml"))
}
ggthemes_data$manyeyes <- load_manyeyes()

load_fivethirtyeight <- function() {
  yaml.load_file(here::here("data-raw", "theme-data", "fivethirtyeight.yml")) |>
    map_dfr(as_tibble)
}
ggthemes_data$fivethirtyeight <- load_fivethirtyeight()

tableau_palette <- function(x) {
  out <- list(
    name = xml_attr(x, "name"),
    type = xml_attr(x, "type")
  )
  out$colors <- tibble(value = rev(map_chr(xml_children(x), xml_text)))
  out
}

tableau_classic <- function() {
  read_xml(here::here("data-raw", "theme-data", "tableau-classic.xml")) |>
    xml_children() |>
    map(tableau_palette)
}

load_tableau <- function() {
  tableau <- yaml.load_file(here::here("data-raw", "theme-data", "tableau.yml"))
  tableau[["color-palettes"]] <- map(
    tableau[["color-palettes"]],
    function(x) {
      map(x, ~ map_dfr(., as_tibble))
    }
  )
  tableau[["shape-palettes"]] <- imap(
    tableau[["shape-palettes"]],
    ~ shape_table(.x, paste0("tableau.yml:shape-palettes/", .y))
  )

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
  out <- yaml.load_file(here::here("data-raw", "theme-data", "solarized.yml"))
  out$Accents <- map_dfr(out[["Accents"]], as_tibble)
  out$Base <- map_dfr(out[["Base"]], as_tibble)
  colors <- deframe(out[["Accents"]])
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
  out <- yaml.load_file(here::here("data-raw", "theme-data", "excel.yml"))
  out$shapes <- shape_table(out$shapes, "excel.yml:shapes")
  out$themes <-
    yaml.load_file(here::here("data-raw", "theme-data", "excel-themes.yml"))
  out
}
ggthemes_data$excel <- load_excel()

load_calc <- function() {
  raw <- yaml.load_file(here::here("data-raw", "theme-data", "libreoffice.yml"))
  out <- map(raw, ~ map_dfr(., as_tibble))
  out$shapes <- shape_table(raw$shapes, "libreoffice.yml:shapes")
  out
}
ggthemes_data$calc <- load_calc()

load_gdocs <- function() {
  raw <- yaml.load_file(here::here("data-raw", "theme-data", "gdocs.yml"))
  out <- map(raw, ~ map_dfr(., as_tibble))
  out$shapes <- shape_table(raw$shapes, "gdocs.yml:shapes")
  out
}
ggthemes_data$gdocs <- load_gdocs()

load_shapes <- function() {
  out <- yaml.load_file(here::here("data-raw", "theme-data", "shapes.yml"))
  out$cleveland <- imap(out$cleveland, ~ shape_table(.x, paste0("shapes.yml:cleveland/", .y)))
  out$tremmel <- imap(out$tremmel, ~ shape_table(.x, paste0("shapes.yml:tremmel/", .y)))
  out$circlefill <- shape_table(out$circlefill, "shapes.yml:circlefill")
  out
}
ggthemes_data$shapes <- load_shapes()


load_hc <- function() {
  yaml.load_file(here::here("data-raw", "theme-data", "hc.yml"))
}
ggthemes_data$hc <- load_hc()

# Generated by data-raw/numbers_palettes.R from the Numbers application
# bundle; see data-raw/reference/numbers/SOURCES.md.
load_numbers <- function() {
  yaml.load_file(here::here("data-raw", "theme-data", "numbers.yml")) |>
    map(~ map_dfr(., as_tibble))
}
ggthemes_data$numbers <- load_numbers()

# save

ggthemes_data <- as.list(ggthemes_data)

usethis::use_data(ggthemes_data, overwrite = TRUE)
