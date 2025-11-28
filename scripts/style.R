#!/usr/bin/env Rscript
air::air_style_pkg(".")
air::air_style_dir("inst/examples/", exclude_files =
               c("ex-few_shape_pal.R",
                  "ex-calc_shape_pal.R",
                  "ex-cleveland_shape_pal.R",
                  "ex-few_shape_pal.R",
                  "ex-palette_pander.R",
                  "ex-scale_shape_stata.R",
                  "ex-scale_shape_tableau.R",
                  "ex-tableau_shape_pal.R",
                  "ex-tableau_shape_pal.R",
                  "ex-theme_calc.R",
                  "ex-theme_economist.R"))
