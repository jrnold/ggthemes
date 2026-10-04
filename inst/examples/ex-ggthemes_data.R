library("scales")

## One element per theme
names(ggthemes_data)

## Colors are stored as tables of names and hex values ...
ggthemes_data$fivethirtyeight
show_col(ggthemes_data$fivethirtyeight$value)

## ... as plain hex vectors ...
show_col(ggthemes_data$manyeyes)

## ... or once per number of colors
show_col(ggthemes_data$solarized$palettes$blue[[4]])

## Shapes give a base R symbol (pch), where there is one, and the Unicode
## character they were transcribed from
stata_shapes <- ggthemes_data$stata$shapes
stata_shapes[c("symbolstyle", "character", "pch")]
show_shapes(stata_shapes$pch)

## Linetypes are dash patterns
show_linetypes(ggthemes_data$stata$linetypes[1:10])
