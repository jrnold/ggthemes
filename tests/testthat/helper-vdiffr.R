expect_doppelganger <- function(title, fig,
                                path = NULL,
                                ...,
                                user_fonts = NULL,
                                verbose = FALSE) {
  # need to call conditionally because vdiffr listed in Suggests (#124)
  testthat::skip_if_not_installed("vdiffr")
  vdiffr::expect_doppelganger(title, fig,
                              path = path,
                              ...,
                              user_fonts = user_fonts,
                              verbose = verbose)
}
