# Robust shape palettes

Date: 2026-09-01
Status: approved design, no open items
Target release: ggthemes 6.1.0 (breaking)

## 1. Problem

ggthemes builds most of its shape palettes out of Unicode glyphs. `data-raw/build.R`
converts a character to a negative pch (`utf_8_to_pch()`: `-utf8ToInt(x)`), and R draws a
negative pch by asking the *font* for that codepoint. Three consequences:

1. **Silent tofu.** If the device's font lacks the glyph, points render as blank boxes with
   no error. Measured on this machine with `systemfonts::glyph_info()`, R's default `sans`
   (Helvetica) covers **1 of the 8** codepoints these palettes rely on:

   | font | `●` 25CF | `◔` 25D4 | `⊕` 2295 | `◁` 25C1 | `✕` 2715 | `✦` 2726 | `⧓` 29D3 | 🐞 1F41E |
   |---|---|---|---|---|---|---|---|---|
   | sans / Helvetica / Arial | ok | — | — | — | — | — | — | — |
   | Apple Symbols | ok | ok | ok | ok | — | — | ok | — |
   | Arial Unicode MS | ok | ok | ok | ok | ok | ok | — | — |
   | STIXGeneral | ok | ok | ok | ok | — | — | ok | — |

   No single font on this machine covers all eight.

2. **Hard failure on some device/locale combinations.** Base `pdf()`/`postscript()` do no
   font fallback and abort with `conversion failure ... in 'mbcsToSbcs'`. Cairo devices and
   `ragg` do fall back, so the same script silently succeeds or fails depending on the
   device — with no error either way in the success-with-tofu case.

3. **Inconsistent appearance.** Glyphs vary in size, weight and baseline between codepoints
   (e.g. tableau `default` uses `U+FF0B` FULLWIDTH PLUS, drawn double-width), and they
   ignore the `fill` aesthetic. `circlefill_shape_pal()` was already deprecated in 5.0.0 for
   exactly this reason; the same defect is unaddressed in `stata`, `calc` and `tableau`.

The font cannot be selected from the theme. `ggplot2::GeomPoint$draw_panel` builds
`pointsGrob(..., gp = gg_par(col, fill, pointsize, stroke))`, and `gg_par()` sets **no**
`fontfamily`. The glyph font is therefore the device default, settable only at device-open
time (`ragg::agg_png(family = ...)`, `cairo_pdf(family = ...)`, `showtext`), never via
`theme(text = element_text(family = ...))`.

Secondary problem: the YAML rows carry `name`, `character`, `unicode` and `pch` as four
independent hand-written fields that must agree, with nothing checking them. They have
already drifted — see §6.

## 2. Goals

In priority order, per the brainstorming session:

1. **Rendering reliability** — a shape palette must not silently render blank boxes.
2. **Aesthetic fidelity** — shapes should be visually consistent in size and weight.

Data integrity and a uniform palette contract are not goals in themselves, but both fall out
of the design and both are required for goal 1 to be correct.

Non-goal: reproducing every source product's symbol set exactly. Where a source shape has no
font-independent equivalent, it is dropped from the safe path rather than approximated.

## 3. Decisions

| # | Decision |
|---|---|
| D1 | Palettes gain `unicode = FALSE`. The default returns base pch; `unicode = TRUE` reproduces today's glyph output. |
| D2 | Where a source shape has no base-pch equivalent, it is **dropped** from the safe path, lowering `max_n`. No approximation, no substitution. |
| D3 | Solid source shapes map to the solid family **pch 15:18**, not the fill-aware 21:25, so a shape scale works standalone without a `fill` aesthetic. |
| D4 | `warn_unicode_pch()`'s locale heuristic is replaced by a real `systemfonts::glyph_info()` coverage probe. |
| D5 | Ships in **6.1.0 as a breaking change**, documented in NEWS.md with `unicode = TRUE` as the restore path. |
| D6 | The safe pch is **derived from a canonical shape name**, not hand-written per row. |
| D7 | Palettes that degrade badly (`tableau "proportions"`, `cleveland` default) truncate honestly and carry a `@note` steering to `unicode = TRUE` or to `alpha`/`fill`. |

### D3 rationale

pch 21:25 are uniform in size and honour `fill` + `stroke`, which is the better answer to
"visually consistent" in isolation. But `geom_point()` defaults `fill = NA`, so a shape scale
returning 21:25 renders every point hollow unless the user also maps or sets `fill` —
destroying the solid/hollow contrast that Stata's palette is built on. A shape scale must
work on its own.

Accepted cost: R draws pch 18 (solid diamond) visibly smaller than 15/16/17. There is no
same-size solid diamond in 0:20. Documented, not worked around.

### D2 rationale

Approximating (e.g. left-triangle → diamond) keeps `max_n` but makes the palette stop being a
reproduction of the source product's symbol set, which is ggthemes' entire premise. Truncation
is the honest failure.

## 4. Design

### 4.1 Shape vocabulary — `R/shape-names.R` (new)

A single internal named vector is the sole source of truth for name → safe pch. It reuses
**ggplot2's own shape names** (`translate_shape_string()`'s vocabulary) so they are already
familiar, extended with names for the shapes ggthemes needs that have no base equivalent.

```r
shape_pch <- c(
  # ggplot2 vocabulary, 0:25
  "square open" = 0, "circle open" = 1, "triangle open" = 2, "plus" = 3,
  "cross" = 4, "diamond open" = 5, "triangle down open" = 6, "square cross" = 7,
  "asterisk" = 8, "diamond plus" = 9, "circle plus" = 10, "star" = 11,
  "square plus" = 12, "circle cross" = 13, "square triangle" = 14,
  "square" = 15, "circle small" = 16, "triangle" = 17, "diamond" = 18,
  "circle" = 19, "bullet" = 20,
  "circle filled" = 21, "square filled" = 22, "diamond filled" = 23,
  "triangle filled" = 24, "triangle down filled" = 25,

  # ASCII-character pch (32:127 regime), universally available
  "less-than" = 60, "letter S" = 83,

  # no font-independent equivalent -> unicode-only
  "triangle down" = NA, "triangle left" = NA, "triangle right" = NA,
  "triangle left open" = NA, "triangle right open" = NA,
  "circle quarter filled" = NA, "circle half filled" = NA,
  "circle three-quarter filled" = NA,
  "circle dot" = NA, "circle ring" = NA,
  "bowtie" = NA, "hourglass" = NA,
  "four pointed star" = NA, "star filled" = NA,
  "blank" = NA
)
```

The vocabulary is a **closed set**: `build.R` fails on any name not in it.

`data-raw/build.R` obtains this table by `source()`-ing `R/shape-names.R`, so there is exactly
one copy. Two copies — one build-side, one package-side — would only relocate the drift this
design exists to eliminate.

Note `"circle small"` (pch 16), not `"circle"` (pch 19), is used for solid circles: 15/16/17/18
are R's size-matched solid family, and 19 is visibly larger.

### 4.2 YAML schema

Rows lose their hand-written `pch` and gain a `shape` name:

```yaml
tremmel:
  '2-overlap':
  - {shape: circle open, unicode: U+25CB, character: ○}
  - {shape: plus,        unicode: U+002B, character: +}
```

(Shown with the §7 corrections applied: the stored row was `{name: WHITE SQUARE, pch: 0}` +
`{name: WHITE CIRCLE, pch: 3}`, where Tremmel §5.1 gives empty circle + plus sign. Under this
schema the label and the value are the same field, so that pairing is unrepresentable.)

`name` (the Unicode character name) is retained as documentation but is no longer load-bearing.

Rows needing a `shape` name, counted from the built data:

| file | rows |
|---|---|
| `tableau.yml` | 66 |
| `shapes.yml` | 25 |
| `stata.yml` | 22 |
| `libreoffice.yml` | 13 |
| `excel.yml` | 9 |
| `gdocs.yml` | 8 |
| `few.yml` | 5 |
| **total** | **148** |

`gdocs.yml` and `excel.yml`'s shape tables (17 rows) are currently read by no R function —
they are built into `ggthemes_data` but no palette consumes them. They are annotated anyway,
so the schema and its validation stay uniform across every shape table.

`stata.yml` keeps its distinct column names (`symbolstyle`, `unicode_value`); only the `pch`
derivation changes.

### 4.3 Build-time validation

`build.R` derives both pch columns and **aborts the build** on any of:

1. `utf8ToInt(character)[1] != strtoi(sub("^U\\+", "", unicode), 16L)` — character and
   codepoint disagree.
2. `shape` not in the vocabulary.
3. A derived safe pch outside `0:25 ∪ 32:127 ∪ NA`.
4. **Per palette**, duplicate safe pch among the shapes that palette actually selects.

Check 4 is deliberately per-palette, not per-table. Stata's full 22-row table legitimately
collapses `smcircle`/`smdiamond`/`smsquare`/`smtriangle` onto the same pch as their full-size
counterparts, because pch encodes symbol identity and delegates size to the `size` aesthetic.
`stata_shape_pal()` already excludes the small variants, so no palette is affected — but a
per-table check would produce a false failure.

### 4.4 `ggthemes_data` output schema

| column | meaning |
|---|---|
| `shape` | canonical name (new, authoritative) |
| `pch` | **safe** base pch, or `NA` when there is no equivalent (was: the negative glyph value) |
| `pch_unicode` | negative glyph value (new name for today's `pch`) |
| `character`, `unicode`, `name` | retained, descriptive only |

`pch` changing meaning is a user-visible breaking change to exported `ggthemes_data`,
documented in NEWS.md.

### 4.5 Runtime constructor — `R/shape-pal.R` (new)

One internal constructor replaces five hand-rolled palette bodies:

```r
new_shape_pal <- function(shapes, unicode = FALSE) {
  values <- shapes[[if (unicode) "pch_unicode" else "pch"]]
  values <- values[!is.na(values)]
  max_n  <- length(values)
  if (unicode) warn_shape_font(shapes)
  f <- function(n) {
    check_pal_n(n, max_n)
    values[seq_len(n)]
  }
  attr(f, "max_n") <- max_n
  f
}
```

This unifies `max_n`, truncation, overflow behaviour and the font warning. Truncation needs no
branch: `NA` in the `pch` column *is* the "no safe equivalent" signal, so the safe `max_n` is
just `sum(!is.na(pch))`.

Overflow behaviour is unchanged from today (`check_pal_n()` warns, then `NA`-pads), but the two
divergent wordings currently in the package — `"This palette can handle a maximum of…"` from
the hand-rolled bodies and `"This manual palette can handle a maximum of…"` from
`scales::manual_pal()` — collapse to the single `check_pal_n()` message.

`stata_shape_pal()` drops its runtime `as.hexmode()` / `str_replace()` re-implementation of
`utf_8_to_pch()` (`R/stata.R:290-293`) and reads the `pch` column like every other palette.
`scales::manual_pal` is no longer used for shapes.

### 4.6 Font coverage check — `warn_shape_font()`

Replaces the locale heuristic in `warn_unicode_pch()`, which today stays silent on this UTF-8
macOS session while `sans` would render 7 of 8 test glyphs as tofu.

```r
warn_shape_font <- function(shapes) {
  if (!rlang::is_installed("systemfonts")) {
    return(warn_unicode_pch(shapes$pch_unicode))   # retained fallback
  }
  family  <- grid::get.gpar("fontfamily")          # "" => device default
  path    <- systemfonts::match_fonts(family)$path
  info    <- systemfonts::glyph_info(shapes$character, path = path)
  missing <- shapes$character[info$index == 0]
  if (length(missing)) cli::cli_warn(...)
}
```

Message shape:

```
Warning: The current device font ("Helvetica") lacks glyphs for 6 of 10
  shapes in this palette: □ ＋ ✕ ∗ ◇ ◁
i These will render as blank boxes.
i Try a font with wider symbol coverage, e.g. ragg::agg_png(family = "DejaVu Sans")
i Or use `unicode = FALSE` for base pch shapes.
```

- `systemfonts` is added to **Suggests**; `warn_unicode_pch()` is kept as the fallback.
- Results are memoised per `(family, palette)` in a package-local environment so a faceted
  plot does not re-probe.
- **Documented limitation:** the warning fires at palette construction, which may precede any
  device being opened. In that case it probes the default device family, which is the right
  guess but only a guess.

Recommended fonts, for the docs:

| font | covers | notes |
|---|---|---|
| DejaVu Sans | Geometric Shapes, Math Operators, Dingbats, Misc Symbols | best single cross-platform pick; free (Bitstream Vera); default on most Linux |
| Noto Sans Symbols 2 | Geometric Shapes Extended, **Misc Math Symbols-B** | effectively the only free font with calc's `⧓` / `⧗`; OFL |
| STIX Two Text | math operators `⊕ ⊙ ⊚ ∗` | right choice for `cleveland_shape_pal(overlap = FALSE)` |
| Arial Unicode MS, Menlo | broad incl. dingbats | already on macOS; no bowtie |
| Apple / Noto Color Emoji | tableau Bug Tracking, Gender, weather | needs a colour-capable device; base `pdf()` cannot draw these at all |

Device matters as much as font: cairo devices and `ragg` do fontconfig fallback; base
`pdf()`/`postscript()` do not.

### 4.7 Public API

Measured safe coverage, using the mapping in §4.1:

| palette | glyph `max_n` | safe `max_n` | dropped from the safe path |
|---|---|---|---|
| `stata_shape_pal()` | 10 | **10** | — (never needed glyphs) |
| `few_shape_pal()` | 5 | 5 | — (already base pch) |
| `tremmel_shape_pal()` | 3 | 3 | — (already base pch) |
| `cleveland_shape_pal(overlap = TRUE)` | 4 | **4** | — (pch 1, 3, 60, 83) |
| `tableau_shape_pal("default")` | 10 | 8 | `◁ ▷` |
| `calc_shape_pal()` | 13 | 7 | `▼ ◀ ▶ ⧓ ⧗ ✦` |
| `tableau_shape_pal("filled")` | 10 | 6 | `★ ▼ ◀ ▶` |
| `cleveland_shape_pal(overlap = FALSE)` | 5 | 3 | `⊙ ⊚` |
| `tableau_shape_pal("proportions")` | 5 | 2 | `◔ ◑ ◕` |

Stata's mapping is exact and complete: `circle→16, diamond→18, square→15, triangle→17, X→4,
plus→3, circle_hollow→1, diamond_hollow→5, square_hollow→0, triangle_hollow→2`.

Signatures gain the argument only where it changes behaviour. `few` and `tremmel` are already
font-independent and get none (YAGNI):

```r
stata_shape_pal(unicode = FALSE)
calc_shape_pal(unicode = FALSE)
tableau_shape_pal(palette = "default", unicode = FALSE)
cleveland_shape_pal(overlap = TRUE, unicode = FALSE)

scale_shape_stata(..., unicode = FALSE)
scale_shape_calc(..., unicode = FALSE)
scale_shape_tableau(palette = "default", ..., unicode = FALSE)
scale_shape_cleveland(overlap = TRUE, ..., unicode = FALSE)
```

`circlefill_shape_pal()` / `scale_shape_circlefill()` remain deprecated and gain nothing.

Per D7, `tableau_shape_pal("proportions")` and `cleveland_shape_pal(overlap = FALSE)` gain a
`@note`: both encode *fill fraction*, which base pch cannot express at all. The note explains
the truncation, points at `unicode = TRUE` with a recommended font, and suggests mapping
`alpha` or `fill` as the idiomatic ggplot2 way to encode a proportion. Their surviving
endpoints (empty circle, full circle) remain meaningful as a 2-value scale.

For `cleveland_shape_pal(overlap = FALSE)` specifically, the truncation is arguably an
*improvement* rather than a loss. Tremmel's Experiment 2 tested exactly this five-symbol
Cleveland set and found the fill-graded circles to be the worst performers measured: "the
empty circles — with or without line or dot filling — separated poorly from each other, with
mean decision times all exceeding 2 seconds. The worst result was for ⊕/⊙, with a mean
decision time of 2.45 seconds" — nearly a second worse than the best pairs, and the pair that
produced the most errors (11). The three shapes that survive the safe path (`○ ● ⊕`) are the
better-separating subset.

## 5. Testing

- **Validation runs as a test, not only as a build step.** The §4.3 checks are re-run in
  `test-shapes.R` against the built `ggthemes_data`, so a stale `.rda` fails `R CMD check`
  instead of passing quietly.
- Per palette, both branches: `max_n`, overflow warning, and safe values ⊆ `0:25 ∪ 32:127`.
- `warn_shape_font()` with `systemfonts` mocked in both directions, plus the
  not-installed fallback path. Existing `warn_unicode_pch()` tests are retained.
- **vdiffr snapshots for the safe branch only.** Snapshotting glyph output would encode the
  build machine's fonts into CI, which is the exact fragility being removed. Existing
  stata/tableau/calc shape snapshots need regeneration.

## 6. Data corrections

Unambiguous, fixed as part of this work:

| file | bug | fix |
|---|---|---|
| `shapes.yml` | cleveland `overlap`: `{name: LATIN CAPITAL LETTER S, unicode: U+0053, pch: 87}` — pch 87 renders **`W`** | `shape: letter S` → 83 (3 of 4 fields agree on S) |
| `libreoffice.yml` | `BLACK DOWN-POINTING CHARACTER` | → `BLACK DOWN-POINTING TRIANGLE` |
| `tableau.yml` | weather `U+1F327` stored as a mojibake character → pch `-61599` instead of `-127783` | restore the correct character |

Under the new schema, checks 1 and 2 of §4.3 make all three unrepresentable in future.

## 7. Tremmel — resolved against the paper

`tremmel_shape_pal()`'s stored data contradicted its own roxygen in 3 of 5 entries. Verified
against the full text of Tremmel (1995), JCGS 4(2), 101–112. **The roxygen is correct in every
disputed case; the stored data is wrong in three.**

Source text, §5 Conclusions:

> **5.1 Two Groups of Data.** "One group should be represented by solid circles or rings, and
> the other group by plus signs or asterisks. If there is much overlap, empty circles should be
> taken for the first group because empty symbols preserve their individuality when they
> overlap."
>
> **5.2 Three Groups of Data.** "Based on the results from Experiment 1, solid circles, empty
> circles, and empty triangles appear to be good choices. However, a second condition may be
> necessary — each symbol should differ from both other symbols in the same feature dimension.
> … Solid circles, plus signs, and empty triangles may be good choices, because in this triple
> each symbol differs from every other symbol in the same feature dimension: The plus signs
> differs from the other symbols in the number of terminators; the circle differs from both
> other symbols in curvature; the triangle differs from both other symbols in line orientation.
> However, this suggestion is not directly supported by our experiments."

Resolution:

| entry | paper | data has | corrected to |
|---|---|---|---|
| `1` | solid circle | `16` | `16` — unchanged |
| `2` | solid circle + plus sign (§5.1) | `16, 1` | **`16, 3`** |
| `2-overlap` | empty circle + plus sign (§5.1) | `0, 3` | **`1, 3`** |
| `3` | solid circle, empty circle, empty triangle (§5.2) | `16, 1, 2` | `16, 1, 2` — unchanged |
| `3-alternate` | solid circle, plus sign, empty triangle (§5.2) | `16, 1, 2` | **`16, 3, 2`** |

The accompanying `name`/`character` fields are corrected with them: `2-overlap` is labelled
`WHITE SQUARE` + `WHITE CIRCLE` where the paper gives empty circle + plus, and `3-alternate` is
labelled `WHITE SQUARE` carrying pch 1. Under the §4.2 schema all five entries become
`shape:` names, so these labels can no longer drift from the values.

`alt` default: §5.2 supports `alt = FALSE` (`16, 1, 2`) as the default, since that triple comes
from Experiment 1's measured results, whereas the `alt = TRUE` triple is argued on
feature-dimension grounds that Tremmel explicitly flags as "not directly supported by our
experiments." `tremmel_shape_pal()` already defaults to `FALSE`; **`scale_shape_tremmel()` is
corrected from `alt = TRUE` to `alt = FALSE`** so a palette and its own scale stop disagreeing
at `n = 3`.

The roxygen's *"line orientation"* gloss for the triangle is **correct** and stays as written —
it quotes §5.2 verbatim. (The abstract's three headline contrasts are brightness, line endings
and curvature; §5.2's three-symbol argument uses line orientation for the triangle. Both are
the paper's own wording, for different claims.)

Also verified, for `cleveland_shape_pal(overlap = FALSE)`: §3.1 states "the five circular
symbols are the ones recommended by Cleveland (1985, p. 196) with a slight modification — the
empty circle with a vertical bar was replaced by an empty circle with a plus sign." The
existing cleveland `default` data (`○ ● ⊕ ⊙ ⊚`) and its roxygen note both follow this
correctly and need no change.

Reference PDF: kept locally at `data-raw/reference/papers/Tremmel1995.pdf`, **untracked** —
`data-raw/reference/` is the established location for non-redistributable vendor and
reference material, whose `.gitignore` tracks only provenance notes and fetch scripts.

## 8. Migration

Ships in 6.1.0. NEWS.md entries:

- BREAKING: `stata_shape_pal()`, `calc_shape_pal()`, `tableau_shape_pal()` and
  `cleveland_shape_pal()` now return base pch by default instead of Unicode glyph codes.
  Pass `unicode = TRUE` to restore the previous values.
- BREAKING: the `pch` column of the shape tables in `ggthemes_data` now holds the safe base
  pch; the previous Unicode-derived values move to `pch_unicode`.
- `max_n` is reduced for `calc`, `tableau` and `cleveland` on the default path, since shapes
  with no font-independent equivalent are dropped.
- Bugfix: `cleveland_shape_pal()` rendered `W` where `S` was intended.
- Bugfix: the LibreOffice and Tableau shape data contained a mislabelled shape and a corrupted
  character respectively.
- BREAKING/Bugfix: `tremmel_shape_pal()` returned symbol sets that did not match Tremmel
  (1995). `n = 2` now returns a solid circle and a plus sign (was two circles), `overlap = TRUE`
  returns an empty circle and a plus sign (was a square and a plus sign), and `alt = TRUE`
  returns a solid circle, plus sign and empty triangle (was identical to `alt = FALSE`, making
  the argument a no-op).
- Bugfix: `scale_shape_tremmel()` defaulted to `alt = TRUE` while `tremmel_shape_pal()`
  defaulted to `alt = FALSE`; both now default to `FALSE`, the variant Tremmel's Experiment 1
  actually measured.
- `warn_unicode_pch()`'s locale guess is replaced by a real font-coverage check when
  `systemfonts` is installed.

The break mostly *fixes* plots rather than changing correct ones: anyone on a font without
coverage is currently getting blank boxes.

## 9. Out of scope

- Custom grid-grob shapes via a ggthemes-supplied geom. This would make the dropped shapes both
  font-independent and faithful, but ggplot2's `shape` aesthetic is pch-only, so it needs a
  parallel geom/scale pair. Recorded as a possible follow-up.
- Exposing the five tableau shape palettes present in the data but not reachable through
  `tableau_shape_pal()` (`Bug Tracking`, `Gender`, `kpi`, `weather`, `Arrows`). They are
  emoji/pictograph sets with no base-pch path at all; a separate decision.
- Un-deprecating `circlefill_shape_pal()`.
