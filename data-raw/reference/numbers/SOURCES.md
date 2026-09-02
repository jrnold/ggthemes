# Apple Numbers reference data

Chart palettes and chart style defaults extracted from the installed
Numbers application bundle, used to build `ggthemes_data$numbers` and to
derive `theme_numbers()`.

Extracted from **Numbers 14.5**, at
`/Applications/Numbers.app/Contents/Resources/`.

| file | source | contents |
|------|--------|----------|
| `plists/*.json` | `*.sfccolor.plist` | the 12 chart palettes, 6 series each |
| `chart-style.xml` | `SDBGDefaultThemeStyleSheet.xml.gz` | chart style defaults |
| `VERSION` | `Info.plist` | `CFBundleShortVersionString` |

## Pipeline

```
Numbers.app --fetch.sh--> plists/*.json --numbers_palettes.R--> theme-data/numbers.yml
```

1. `./fetch.sh` copies the palette plists out of the bundle (converting
   each to JSON with `plutil`) and gunzips the chart style sheet. Set
   `NUMBERS_APP` if Numbers is not in `/Applications`.
2. `Rscript data-raw/numbers_palettes.R` reads those persisted files and
   writes `data-raw/theme-data/numbers.yml`.
3. `Rscript data-raw/build.R` folds that YAML into `ggthemes_data`.

Stage 2 never reads `/Applications`, so the extracted files can be
diffed across Numbers versions and re-run without the app open.

## Color spaces

Series colors are stored in mixed color spaces -- 64 of the 72 are
`calibrated-rgb`, 8 are `device-cmyk`. The CMYK entries go through
ColorSync (`cmyk-to-srgb.swift`), not a naive `1 - x` conversion. The
two disagree materially: the "Blue" palette's first series is `#5E86B8`
through ColorSync and `#5EA3FF` naively.

## Chart style defaults

`chart-style.xml` holds a `chart-style-default` property map that
`theme_numbers()` is derived from. The properties that matter:

| property | value |
|---|---|
| `SFC2DChartBackgroundFillProperty` | null (no panel fill) |
| `SFC2DShowValueDirectionGridLinesProperty` | 1 |
| `SFC2DValueDirectionGridLineStrokeProperty` | `#AAAAAA`, width 1, solid |
| `SFC2DShowCategoryDirectionGridLinesProperty` | 0 |
| `SFC2DShowBottomBorderProperty` | 1 (black, width 1) |
| `SFC2DShowLeftBorderProperty`, right, top | 0 |
| `SFCCategoryAxisShowMajorTickMarksProperty` | 0 |
| `SFCValueAxisShowMajorTickMarksProperty` | 0 |
| `SFCLegendFillProperty` | null |
| `SFCLegendStrokeProperty` | pattern `empty` (no border) |

## Redistribution

These are Apple's files. They are kept out of version control (see
`data-raw/reference/.gitignore`) and are for local extraction only --
they must not be redistributed in the package. Only these notes, the
two scripts, and the generated `numbers.yml` are committed.
