## R CMD check notes

-   "Author field differs from that derived from Authors@R" is due to use of
    an ORCID identifier.

-   "Note: found ... marked UTF-8 strings": The UTF strings are necessary to the package.
    They encode specific non-ASCII characters to use as symbols.

-   In `DESCRIPTION`, the words "Geoms", "Stata", "Tufte", "Tufte's", 
    and "geoms" are not misspelled.

-   "Found the following (possibly) invalid URLs" check": These URLs are valid:

    -   https://policyviz.com/2017/01/12/150-color-palettes-for-excel/ (times out)
    -   https://spiekermann.com/en/itc-officina-display/ (libcurl error 38 "Connection timed out")
    -   https://twitpic.com/9gfg5q (391, 503)
    -   https://twitpic.com/9gfg5q (391, 503)
    -   https://twitpic.com/awbua0 (391, 503)
    -   https://twitpic.com/awbua0 (391, 503)
    -   https://twitpic.com/b1avj6 (391, 503)
    -   https://twitpic.com/b2e3v2 (391, 503)
    -   https://twitter.com/WSJGraphics (400)
    -   https://www.canva.com/learn/ (403)
    -   https://www.canva.com/learn/100-color-combinations/ (403)
    -   https://www.canva.com/learn/website-color-schemes/ (403)
    -   https://www.highcharts.com/ (503)
    -   https://www.highcharts.com/demo (503)
    -   https://www.jstor.org/stable/1390760  (391, 503)
    -   https://www.jstor.org/stable/2289649  (391, 503)
