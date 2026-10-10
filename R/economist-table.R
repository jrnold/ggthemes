#' Style a gt table as an Economist table
#'
#' Themes for [gt][gt::gt] tables in the two styles of *The Economist*'s
#' charts.
#'
#' * `gt_theme_economist()` is the classic print table of 2012 to 2016, as
#'   measured on the paper's tables: black type on the blue-gray ground, bold
#'   column heads and row headers (the stub, made with
#'   `gt::gt(rowname_col = )`), a solid black rule under the heads, dotted
#'   black rules between the rows, a solid black rule at the foot and no fills.
#' * `gt_theme_economist_2017()` is the table of *The Economist visual
#'   styleguide* (v1.2, 4 May 2017): condensed type on the print or web ground,
#'   medium-weight column heads over a thin rule, no rules between the rows and
#'   every second row filled.
#'
#' The themes set the table's own options, so they apply in every gt output
#' format, though the finer settings (line heights and vertical alignment)
#' are CSS and need HTML output and a table id, given as `gt::gt(id = )`.
#' To draw the red tab, title, subtitle, footnote and source around the table,
#' as on a chart, use [economist_table()].
#'
#' @param data A table made with [gt::gt()].
#' @param width The table's width, in points: 160 is one column of the
#'   print edition.
#' @param font The font stack, a character vector or a list as
#'   [gt::opt_table_font()] takes it, with the first font that is installed
#'   used. The paper's typefaces are not freely available: the classic default
#'   is Helvetica, and the 2017 default is Fira Sans Condensed (load it with
#'   [gt::google_font()] if it is not installed).
#' @param media For `gt_theme_economist_2017()`, `"print"` or `"web"`: the
#'   ground and text colors of the print edition or of the website.
#' @param stripe For `gt_theme_economist_2017()`, whether to fill every second
#'   row, as the 2017 guide does "to help with reading".
#'
#' @return The gt table, styled.
#' @family themes economist
#' @family economist 2017
#' @export
#' @example inst/examples/ex-gt_theme_economist.R
gt_theme_economist <- function(data, width = 160, font = c("Helvetica", "Arial", "sans-serif")) {
  check_gt_tbl(data)
  bg <- deframe(ggthemes::ggthemes_data[["economist"]][["bg"]])
  data <- gt::tab_options(
    data,
    table.width = sprintf("%gpt", width),
    table.background.color = unname(bg["blue-gray"]),
    table.font.size = "7pt",
    table.font.color = "black",
    table.border.top.style = "none",
    table.border.bottom.style = "none",
    table.margin.left = "0",
    table.margin.right = "0",
    heading.align = "left",
    heading.title.font.size = "9.5pt",
    heading.title.font.weight = "bold",
    heading.subtitle.font.size = "7.5pt",
    heading.border.bottom.style = "none",
    heading.padding = "0",
    column_labels.font.weight = "bold",
    column_labels.vlines.style = "none",
    stub.border.style = "none",
    stub.background.color = "transparent",
    column_labels.border.top.style = "none",
    column_labels.border.bottom.style = "solid",
    column_labels.border.bottom.width = "0.75pt",
    column_labels.border.bottom.color = "black",
    column_labels.padding = "2pt",
    column_labels.padding.horizontal = "2pt",
    row_group.font.weight = "bold",
    row_group.background.color = "transparent",
    row_group.border.top.style = "none",
    row_group.border.bottom.style = "solid",
    row_group.border.bottom.width = "0.75pt",
    row_group.border.bottom.color = "black",
    row_group.padding = "2pt",
    row_group.padding.horizontal = "2pt",
    table_body.border.top.style = "none",
    table_body.border.bottom.style = "solid",
    table_body.border.bottom.width = "0.75pt",
    table_body.border.bottom.color = "black",
    table_body.hlines.style = "dotted",
    table_body.hlines.width = "0.75pt",
    table_body.hlines.color = "black",
    data_row.padding = "2.5pt",
    data_row.padding.horizontal = "2pt",
    footnotes.font.size = "6.2pt",
    source_notes.font.size = "6.2pt",
    source_notes.padding = "4pt",
    source_notes.border.bottom.style = "none",
    container.padding.x = "0",
    container.padding.y = "0"
  )
  data <- gt::opt_table_font(data, font = font)
  # Row headers, the stub of `gt::gt(rowname_col = )`, are bold, as the column heads are.
  data <- gt::tab_style(data, gt::cell_text(weight = "bold"), gt::cells_stub())
  economist_table_css(data, line_height = 8.5, flush = TRUE)
}

#' @rdname gt_theme_economist
#' @export
gt_theme_economist_2017 <- function(
  data,
  media = c("print", "web"),
  width = 160,
  stripe = TRUE,
  font = c("Fira Sans Condensed", "Roboto Condensed", "Arial Narrow", "sans-serif")
) {
  check_gt_tbl(data)
  media <- rlang::arg_match(media)
  pal <- ggthemes::ggthemes_data[["economist_2017"]][[media]]
  data <- gt::tab_options(
    data,
    table.width = sprintf("%gpt", width),
    table.background.color = pal$ground,
    table.font.size = "7.5pt",
    table.font.color = pal$text,
    table.font.weight = "300",
    table.border.top.style = "none",
    table.border.bottom.style = "none",
    table.margin.left = "0",
    table.margin.right = "0",
    heading.align = "left",
    heading.title.font.size = "9.5pt",
    heading.title.font.weight = "bold",
    heading.subtitle.font.size = "8pt",
    heading.border.bottom.style = "none",
    heading.padding = "0",
    column_labels.font.weight = "500",
    column_labels.vlines.style = "none",
    stub.border.style = "none",
    stub.background.color = "transparent",
    row.striping.include_stub = stripe,
    column_labels.border.top.style = "none",
    column_labels.border.bottom.style = "solid",
    column_labels.border.bottom.width = "0.5pt",
    column_labels.border.bottom.color = pal$text,
    column_labels.padding = "2pt",
    column_labels.padding.horizontal = "3pt",
    row_group.font.weight = "500",
    row_group.background.color = "transparent",
    row_group.border.top.style = "none",
    row_group.border.bottom.style = "solid",
    row_group.border.bottom.width = "0.5pt",
    row_group.border.bottom.color = pal$text,
    row_group.padding = "2pt",
    row_group.padding.horizontal = "3pt",
    table_body.border.top.style = "none",
    table_body.border.bottom.style = "none",
    table_body.hlines.style = "none",
    data_row.padding = "2pt",
    data_row.padding.horizontal = "3pt",
    row.striping.background_color = pal$highlight %||% pal$box,
    row.striping.include_table_body = stripe,
    footnotes.font.size = "6.5pt",
    source_notes.font.size = "6.5pt",
    source_notes.padding = "3pt",
    source_notes.border.bottom.style = "none",
    container.padding.x = "0",
    container.padding.y = "0"
  )
  data <- gt::opt_table_font(data, font = font)
  data <- gt::tab_style(data, gt::cell_text(color = pal$source), gt::cells_source_notes())
  economist_table_css(data, line_height = 9, flush = FALSE)
}

#' Draw a gt table as an Economist chart
#'
#' Styles a [gt][gt::gt] table with [gt_theme_economist()] or
#' [gt_theme_economist_2017()] and sets it in the frame of a chart: the ground,
#' the red tab, a bold title and a subtitle above it, and a footnote and the
#' source below it.
#'
#' * `"classic"`: the 2012 to 2016 print table, with the red tab upright at
#'   the top left, flush with the corner, and the footnote and source flush
#'   left.
#' * `"2017"`: the 2017 guide's table, with the red tab lying above the title
#'   and the footnote ranged right of the source.
#'
#' The frame is HTML and CSS, so the result is for HTML output only: R
#' Markdown and Quarto documents, pkgdown sites, Shiny and the RStudio viewer.
#' For other formats, style the table with the theme alone.
#'
#' @param data A table made with [gt::gt()].
#' @param title,subtitle,source,footnote Text for the frame, or `NULL` for
#'   none. Line breaks (`"\n"`) are kept. Text is escaped; wrap it in
#'   [htmltools::HTML()] to pass markup.
#' @param style `"classic"` or `"2017"`.
#' @param media For `style = "2017"`, `"print"` or `"web"`.
#' @param width The width of the chart, in points: 160 is one column of the
#'   print edition.
#' @param ... Passed to the theme, as `stripe` or `font`.
#'
#' @return An HTML fragment, of class `html`, which prints in the viewer and
#'   knits into HTML documents.
#' @family themes economist
#' @family economist 2017
#' @export
#' @example inst/examples/ex-economist_table.R
economist_table <- function(
  data,
  title = NULL,
  subtitle = NULL,
  source = NULL,
  footnote = NULL,
  style = c("classic", "2017"),
  media = c("print", "web"),
  width = 160,
  ...
) {
  check_gt_tbl(data)
  style <- rlang::arg_match(style)
  media <- rlang::arg_match(media)
  # The table fills the frame; the frame has the chart's width.
  if (style == "classic") {
    data <- gt_theme_economist(data, ...)
    bg <- deframe(ggthemes::ggthemes_data[["economist"]][["bg"]])
    ground <- unname(bg["blue-gray"])
    tab <- unname(bg["economist red"])
    text <- source_colour <- "black"
    font <- "Helvetica,Arial,sans-serif"
  } else {
    data <- gt_theme_economist_2017(data, media = media, ...)
    pal <- ggthemes::ggthemes_data[["economist_2017"]][[media]]
    ground <- pal$ground
    tab <- pal$accent
    text <- pal$text
    source_colour <- pal$source
    font <- "'Fira Sans Condensed','Roboto Condensed','Arial Narrow',sans-serif"
  }
  data <- gt::tab_options(data, table.width = "100%", table.background.color = "transparent")
  # The finer CSS is scoped to this frame, since the table may have no id; the scope is a hash of the content, so it is
  # the same each time.
  scope <- paste0(
    "ggthemes-economist-table-",
    substr(rlang::hash(list(data, title, subtitle, source, footnote)), 1, 12)
  )
  # gt draws a random id for a table without one, so the user's random-number state is put back afterwards.
  table_html <- with_preserved_seed(gt::as_raw_html(data, inline_css = TRUE))
  rules <- economist_table_rules(
    paste0("#", scope),
    line_height = if (style == "classic") 8.5 else 9,
    flush = style == "classic"
  )

  block <- function(x, css) {
    if (is.null(x)) {
      return("")
    }
    sprintf('<div style="%s">%s</div>', css, economist_table_text(x))
  }
  if (style == "classic") {
    head <- paste0(
      sprintf('<div style="position:absolute;left:0;top:0;width:5pt;height:15pt;background:%s"></div>', tab),
      block(title, "font-weight:700;font-size:9.5pt;line-height:11pt"),
      block(subtitle, "font-size:7.5pt;line-height:9pt")
    )
    foot <- paste0(
      block(footnote, "font-size:6.2pt;line-height:7.5pt;margin-top:4pt"),
      block(source, sprintf("font-size:6.2pt;line-height:7.5pt;margin-top:%s", if (is.null(footnote)) "4pt" else "1pt"))
    )
    padding <- "5pt 11pt 5pt 11pt"
  } else {
    head <- paste0(
      sprintf('<div style="width:15pt;height:5pt;background:%s;margin:0 0 4pt 0"></div>', tab),
      block(title, "font-weight:700;font-size:9.5pt;line-height:11pt"),
      block(subtitle, "font-size:8pt;line-height:9.5pt")
    )
    # The cells are inset 3pt; the title and the source line up with them.
    head <- sprintf('<div style="padding:0 3pt">%s</div>', head)
    foot <- if (is.null(source) && is.null(footnote)) {
      ""
    } else {
      sprintf(
        paste0(
          '<div style="display:flex;justify-content:space-between;align-items:flex-end;gap:6pt;',
          'font-size:6.5pt;line-height:8pt;margin-top:3pt;color:%s"><span>%s</span><span style="text-align:right">%s',
          "</span></div>"
        ),
        source_colour,
        if (is.null(source)) "" else economist_table_text(source),
        if (is.null(footnote)) "" else economist_table_text(footnote)
      )
    }
    foot <- sprintf('<div style="padding:0 3pt">%s</div>', foot)
    padding <- "0 0 4pt 0"
  }
  html <- paste0(
    sprintf(
      paste0(
        '<style>%s</style><div id="%s" class="ggthemes-economist-table" style="position:relative;width:%gpt;',
        "box-sizing:border-box;",
        "background:%s;padding:%s;margin:0 0 1em 0;color:%s;font-family:%s\">"
      ),
      rules,
      scope,
      width,
      ground,
      padding,
      text,
      font
    ),
    head,
    '<div style="height:5pt"></div>',
    table_html,
    foot,
    "</div>"
  )
  htmltools::browsable(htmltools::HTML(html))
}

# Evaluates `expr` and puts back the random-number state as it was.
with_preserved_seed <- function(expr) {
  env <- globalenv()
  had_seed <- exists(".Random.seed", envir = env, inherits = FALSE)
  if (had_seed) {
    seed <- get(".Random.seed", envir = env, inherits = FALSE)
    on.exit(assign(".Random.seed", seed, envir = env), add = TRUE) # nolint: object_name_linter. R's own name.
  } else {
    on.exit(if (exists(".Random.seed", envir = env, inherits = FALSE)) rm(".Random.seed", envir = env), add = TRUE)
  }
  expr
}

check_gt_tbl <- function(data, arg = rlang::caller_arg(data), call = rlang::caller_env()) {
  rlang::check_installed(c("gt", "htmltools"), reason = "to style Economist tables.", call = call)
  if (!inherits(data, "gt_tbl")) {
    cli::cli_abort(
      "{.arg {arg}} must be a gt table made with {.fn gt::gt}, not {.obj_type_friendly {data}}.",
      call = call
    )
  }
}

# Text for the frame: escaped unless it is already HTML, with line breaks kept.
economist_table_text <- function(x) {
  if (inherits(x, "html")) {
    return(as.character(x))
  }
  gsub("\n", "<br>", htmltools::htmlEscape(paste(x, collapse = "\n")), fixed = TRUE)
}

# CSS the table options cannot set. pkgdown gives every table Bootstrap's `table` class, whose cells are filled with
# --bs-table-bg (white), so that is cleared for every gt table; the rest is scoped to the table's id, when it has one.
economist_table_css <- function(data, line_height, flush) {
  id <- gt_table_id(data)
  css <- "table.gt_table { --bs-table-bg: transparent; }"
  if (!is.null(id)) {
    css <- paste(css, economist_table_rules(paste0("#", id), line_height, flush), sep = "\n")
  }
  gt::opt_css(data, css)
}

# Line heights and vertical alignment for the tables inside `scope` (a CSS selector), and, with `flush`, outer columns
# flush with the edges, as on the classic tables (the 2017 tables inset theirs). The rules are `!important` because gt
# writes the cells' styles inline.
economist_table_rules <- function(scope, line_height, flush = TRUE) {
  # Selectors and their declarations; each selector is scoped on its own.
  rules <- list(
    c("table.gt_table", "--bs-table-bg: transparent; line-height: LHpt !important; margin: 0 !important;"),
    c(".gt_col_heading", "vertical-align: bottom !important; line-height: LHpt !important;"),
    c(".gt_row|.gt_stub", "vertical-align: top !important; line-height: LHpt !important;"),
    c(".gt_col_heading:first-child|.gt_row:first-child|.gt_stub|.gt_group_heading", "padding-left: 0 !important;"),
    c(".gt_col_heading:last-child|.gt_row:last-child", "padding-right: 0 !important;")
  )
  if (!flush) {
    rules <- rules[1:3]
  }
  css <- vapply(
    rules,
    function(r) {
      selectors <- paste(scope, strsplit(r[[1]], "|", fixed = TRUE)[[1]], collapse = ", ")
      paste0(selectors, " { ", gsub("LH", format(line_height), r[[2]], fixed = TRUE), " }")
    },
    character(1)
  )
  paste(css, collapse = "\n")
}

# The id given as `gt::gt(id = )`, or NULL. gt has no accessor for it, so this reads the table's options.
gt_table_id <- function(data) {
  opts <- data[["_options"]]
  id <- tryCatch(opts$value[[which(opts$parameter == "table_id")]], error = function(e) NULL)
  if (is.null(id) || length(id) != 1 || is.na(id) || !nzchar(id)) NULL else id
}
