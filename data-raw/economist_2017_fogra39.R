# Convert every swatch of the 2017 styleguide's print chart palette (p.11)
# from the CMYK the guide specifies to sRGB, through ISO Coated v2 (FOGRA39),
# and print the `swatches:` records for data-raw/theme-data/economist_2017.yml.
#
# Why FOGRA39: the guide's PDF stores every colour as DeviceCMYK, with no
# embedded profile. Its web swatches (p.12) were typed in as hex and stored by
# Illustrator as CMYK; converting those CMYK values back through ISO Coated v2
# recovers the printed hex exactly (to 1/255) for 27 of the 67, and to a median
# CIEDE2000 of 0.4, where U.S. SWOP, FOGRA45 and a PDF viewer's unmanaged
# conversion recover at most 2. So ISO Coated v2 was the document's colour
# space, and it is the profile to show the print swatches through.
#
# The conversion is relative colorimetric with black-point compensation,
# Photoshop's and Illustrator's default: paper white maps to #FFFFFF and the
# press's deepest black to #000000. Out-of-gamut channels are clipped.
#
# Requires LittleCMS's `transicc` (Homebrew: little-cms2) and the ECI profile
# ISOcoated_v2_eci.icc, which the ECI no longer hosts; it is in Debian's
# icc-profiles 2.1-2 package. The profile is licensed and is not shipped here.
#
# Usage: Rscript data-raw/economist_2017_fogra39.R PATH/TO/ISOcoated_v2_eci.icc

profile <- commandArgs(trailingOnly = TRUE)[1]
stopifnot(!is.na(profile), file.exists(profile))
stopifnot(unname(tools::md5sum(profile)) == "bda07efcacf5377e91edacb0454ea7e5")

# name, group and CMYK (percent) as printed on p.11.
swatches <- read.table(
  header = TRUE,
  stringsAsFactors = FALSE,
  text = '
name         group       c    m   y   k
"econ red"   main        0    100 100 0
"red1"       main        10   70  50  0
"red text"   main        12   80  60  0
"blue1"      main        90   50  15  5
"blue2"      main        67   0   18  0
"blue2 text" main        82   0   18  8
"gold"       secondary   12   30  70  0
"maroon"     secondary   0    75  35  45
"mauve"      secondary   27   42  25  10
"teal"       secondary   85   0   30  20
"mint"       secondary   53   0   26  0
"purple"     bright      40   70  30  6
"coral"      bright      0    68  73  0
"orange"     bright      6    40  100 0
"lime"       bright      33   13  95  2
"navy"       dark        85   10  0   58
"dark teal"  dark        80   25  50  50
"olive"      dark        38   30  43  26
"print bkgd" background  7.5  0   0   5
"highlight"  background  15   0   0   10
"number box" background  22.5 0   0   15
"grid lines" neutral     10   0   0   25
"grey box"   neutral     30   0   0   50
"grey text"  neutral     20   0   0   80
"black 25"   black       0    0   0   25
"black 50"   black       0    0   0   50
"black 75"   black       0    0   0   75
"black 100"  black       0    0   0   100
'
)

input <- do.call(paste, swatches[c("c", "m", "y", "k")])
out <- system2(
  "transicc",
  c("-i", shQuote(profile), "-o", "'*sRGB'", "-t", "1", "-b", "-n"),
  input = input,
  stdout = TRUE,
  stderr = FALSE
)
out <- grep("^\\s*-?[0-9.]+\\s+-?[0-9.]+\\s+-?[0-9.]+\\s*$", out, value = TRUE)
stopifnot(length(out) == nrow(swatches))
rgb <- do.call(rbind, lapply(strsplit(trimws(out), "\\s+"), as.numeric))
rgb <- pmin(pmax(round(rgb), 0), 255)
swatches$value <- grDevices::rgb(rgb[, 1], rgb[, 2], rgb[, 3], maxColorValue = 255)

cat(sprintf(
  '  - {name: "%s", group: "%s", "c": %s, "m": %s, "y": %s, "k": %s, value: \'%s\'}\n',
  swatches$name, swatches$group, swatches$c, swatches$m, swatches$y, swatches$k, swatches$value
), sep = "")
