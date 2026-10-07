# Draw and measure on a device that knows the system fonts, not on base R's pdf().
#
# economist_2017_font() picks Fira Sans Condensed whenever it is installed.
# pdf() knows only the PostScript font database, so with that font installed
# every chart measured or drawn on it warns "font family not found in
# PostScript font database". cairo_pdf(), the device ?theme_economist_2017
# recommends, uses the system fonts, and so does ragg. Charts go to temporary
# files, so no Rplots file is left behind.
#
# capabilities("cairo") only says R was built with cairo: some builds cannot
# load it ("failed to load cairo DLL"), so each device is tried before it is
# chosen, and the default is left alone if none opens cleanly.
choose_test_device <- function() {
  candidates <- list(
    function(...) grDevices::cairo_pdf(filename = tempfile(fileext = ".pdf"), ...),
    function(...) ragg::agg_png(filename = tempfile(fileext = ".png"), ...)
  )
  for (open in candidates) {
    works <- tryCatch(
      {
        withCallingHandlers(
          open(),
          warning = function(w) stop(conditionMessage(w), call. = FALSE)
        )
        grDevices::dev.off()
        TRUE
      },
      error = function(e) FALSE
    )
    if (works) {
      return(open)
    }
  }
  NULL
}

test_device <- choose_test_device()
if (!is.null(test_device)) {
  withr::local_options(device = test_device, .local_envir = teardown_env())
}
