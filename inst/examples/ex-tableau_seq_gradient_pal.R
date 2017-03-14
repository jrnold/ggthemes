### Name: tableau_seq_gradient_pal
### Title: Tableau sequential colour gradient palettes (continuous)
### Aliases: tableau_seq_gradient_pal

### ** Examples

library("scales")
x <- seq(0, 1, length = 25)
show_col(tableau_seq_gradient_pal('Red')(x))
show_col(tableau_seq_gradient_pal('Blue')(x))
show_col(tableau_seq_gradient_pal('Purple Sequential')(x))



