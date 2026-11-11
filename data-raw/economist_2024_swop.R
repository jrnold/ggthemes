# Render the inferred CMYK specs of the 2024 Economist print chart colours to
# sRGB through U.S. Web Coated (SWOP) v2, compare them with the colours the
# published print charts show, and print the `palette:` records for the print
# section of data-raw/theme-data/economist_2024.yml.
#
# Why these specs: no print specification for the 2024 design is public. The
# print values are not an ICC translation of the web values: soft-proofing the
# web colours through SWOP, FOGRA39, GRACoL 2006, SWOP 2006 or Apple Generic
# CMYK misses the print colours by a median CIEDE2000 of 5.2 to 5.8, no closer
# than the web colours themselves. Instead, searching round CMYK builds (5%
# steps; 1% for the grounds) for the simplest one that renders to each print
# colour finds a fit through SWOP with a median CIEDE2000 of 0.2, against 1.1
# to 1.6 for the other profiles. (That search quantised CMYK to 8 bits; through
# transicc here, every series and ground colour is within 0.6, and red and dark
# gray are byte-exact.) SWOP is also the profile the classic charts were
# exported through from 2015. The red is the brand guide's print spec for
# Economist Red, 0/100/100/0.
#
# The conversion is relative colorimetric with black-point compensation, the
# Adobe default. Requires LittleCMS's `transicc` (Homebrew: little-cms2) and
# USWebCoatedSWOP.icc from Adobe's end-user ICC profile pack, which is licensed
# and is not shipped here.
#
# Usage: Rscript data-raw/economist_2024_swop.R PATH/TO/USWebCoatedSWOP.icc

profile <- commandArgs(trailingOnly = TRUE)[1]
stopifnot(!is.na(profile), file.exists(profile))
stopifnot(unname(tools::md5sum(profile)) == "79d7e984ea3ac74eed7cc92bf6b22a0d")

# The observed print colour, the simplest CMYK build that reproduces it, and
# how sure the spec is. "medium": a non-round build, or one of several equally
# good fits, or (blue) a colour that varied in 2024 print charts. "low": no
# build reproduces the colour, which anti-aliasing blurs.
specs <- read.table(
  header = TRUE,
  stringsAsFactors = FALSE,
  text = '
name               role       observed  c   m   y   k   confidence
"red"              series     #ED1C24   0   100 100 0   high
"single red"       series     #F04F38   0   85  85  0   high
"salmon"           series     #F8AB90   0   40  40  0   high
"blue"             series     #28479D   95  85  0   0   medium
"light blue"       series     #659BD2   60  30  0   0   high
"dark gray"        series     #636466   0   0   0   75  high
"light gray"       series     #C6C8CA   0   0   0   25  high
"panel"            ground     #ECEBE0   0   0   6   8   medium
"panel alternate"  ground     #F3F1E6   4   3   9   0   medium
"text"             text       #24211E   50  45  50  85  low
',
  comment.char = ""
)

input <- do.call(paste, specs[c("c", "m", "y", "k")])
out <- system2(
  "transicc",
  c("-i", shQuote(profile), "-o", "'*sRGB'", "-t", "1", "-b", "-n"),
  input = input,
  stdout = TRUE,
  stderr = FALSE
)
out <- grep("^\\s*-?[0-9.]+\\s+-?[0-9.]+\\s+-?[0-9.]+\\s*$", out, value = TRUE)
stopifnot(length(out) == nrow(specs))
rgb <- do.call(rbind, lapply(strsplit(trimws(out), "\\s+"), as.numeric))
rgb <- pmin(pmax(round(rgb), 0), 255)
specs$hex <- grDevices::rgb(rgb[, 1], rgb[, 2], rgb[, 3], maxColorValue = 255)
specs$delta_e <- round(
  diag(farver::compare_colour(
    farver::decode_colour(specs$hex),
    farver::decode_colour(specs$observed),
    from_space = "rgb",
    method = "cie2000"
  )),
  1
)

cat(
  sprintf(
    '  - {name: "%s", role: "%s", cmyk: "%s/%s/%s/%s", hex: \'%s\', observed: \'%s\', delta_e: %s, confidence: "%s"}\n',
    specs$name,
    specs$role,
    specs$c,
    specs$m,
    specs$y,
    specs$k,
    specs$hex,
    specs$observed,
    format(specs$delta_e, nsmall = 1),
    specs$confidence
  ),
  sep = ""
)
