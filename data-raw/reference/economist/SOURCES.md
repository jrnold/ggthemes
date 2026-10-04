# Economist chart style reference

`theme_economist()`, `theme_economist_white()` and `economist_pal()`
draw the classic, pre-2017 Economist style. Their colours (`fg` and `bg`
in `data-raw/theme-data/economist.yml`) were sampled from charts published
in 2012; the comments in `economist_pal()` name the charts each palette
order came from. 7.0.0 briefly replaced this style with the 2017 design
described below; the classic style was restored after that release.

The 2017 reference is *The Economist visual styleguide*, version 1.2,
dated 4 May 2017 and issued by the paper's own graphics desk. It is the
source of the `scales` element of `economist.yml` only: the "equal
lightness colour scales" on p.12, used by `economist_seq_pal()`,
`economist_gradient_pal()` and the `scale_*_economist_c()` and
`scale_*_economist_ordinal()` scales. p.12 is the guide's only page
giving hex values, and the scales are quoted from it verbatim.

## Reference images

None are checked in. The styleguide PDF is The Economist's own
material and must not be redistributed in the package; see
`data-raw/reference/.gitignore`. Re-download a local copy with
`data-raw/reference/economist/fetch.sh`.
