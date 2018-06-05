library("ggplot2")

PT_TO_MM <- 0.352778

# Default font is Liberation Sans
theme_libre <- function(base_size = 10,
                        base_family = "sans") {
  colorlist <- list(gray = "#B3B3B3")
  theme_bw(base_family = base_family,
           base_size = base_size) +
    theme(
      text = element_text(colour = "black"),
      line = element_line(
          linetype = "solid",
          colour = colorlist$gray,
          size = 0.5 * PT_TO_MM
      ),
      rect = element_rect(
        fill = "white",
        linetype = "solid",
        colour = colorlist$gray,
        size = 0.5 * PT_TO_MM
      ),
      panel.grid.major = element_line(
        linetype = "solid",
        colour = colorlist$gray,
        size = 0.5 * PT_TO_MM
      ),
      axis.title = element_text(
        size = 9
      ),
      axis.text = element_text(
        size = 10
      ),
      axis.ticks = element_line(
        colour = colorlist$gray
      ),
      panel.background = element_rect(
        colour = colorlist$gray,
        size = 0.5 * PT_TO_MM
      ),
      title = element_text(
        face = "plain",
        hjust = 0.5
      ),
      plot.title = element_text(
        size = 13,
        hjust = 0.5
      ),
      plot.subtitle = element_text(
        size = 11,
        hjust = 0.5
      ),
      panel.grid.major.x = element_blank(),
      panel.grid.minor = element_blank(),
      legend.position = "right",
      strip.background = element_blank(),
      strip.text = element_text(size = 9),
      legend.title = element_text(
        size = 9
      )
    )

}

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg,  colour = factor(gear))) +
  facet_wrap(~am) +
  labs(title = "Title", subtitle = "Subtitle") +
  theme_libre()

print(p + theme_libre())

# Default Font is Calibri
theme_excel <- function(base_size = 9,
                        base_family = "sans") {
  colorlist <- list(lt_gray = "#D9D9D9",
                    gray = "#BFBFBF",
                    dk_gray = "#595959")
  theme_bw(base_family = base_family,
           base_size = base_size) +
    theme(
      text = element_text(
        colour = colorlist$dk_gray,
        size = base_size
      ),
      line = element_line(
        linetype = "solid",
        colour = colorlist$gray
      ),
      rect = element_rect(
        linetype = 0,
        colour = "white"
      ),
      panel.grid.major = element_line(
        linetype = "solid",
        colour = colorlist$gray,
        size = 0.75 * PT_TO_MM
      ),
      panel.grid.minor = element_blank(),
      axis.title = element_blank(),
      axis.text = element_text(
         colour = colorlist$dk_gray,
         size = 9
      ),
      strip.background = element_rect(
        fill = NA
      ),
      strip.text = element_text(
        colour = colorlist$dk_gray,
        size = 9
      ),
      axis.ticks = element_blank(),
      panel.background = element_blank(),
      panel.border = element_rect(colour = NA),
      title = element_text(
        face = "plain",
        hjust = 0.5
      ),
      plot.title = element_text(
        size = 14,
        hjust = 0.5
      ),
      plot.subtitle = element_blank(),
      legend.position = "bottom",
      legend.text = element_text(
        size = 9,
        colour = colorlist$dk_gray
      ),
      legend.title = element_blank(),
    )
}

# Default Font is Roboto
theme_gdocs <- function(base_size = 12,
                        base_family = "sans") {
  colorlist <- list(lt_gray = "#CCCCCC",
                    dk_gray = "#757575")
  theme_bw(base_family = base_family,
           base_size = base_size) +
    theme(
      text = element_text(
        colour = colorlist$dk_gray,
        size = base_size
      ),
      line = element_line(
        linetype = "solid",
        colour = colorlist$lt_gray
      ),
      rect = element_rect(
        linetype = 0,
        fill = "white",
        colour = NA
      ),
      panel.grid.major = element_line(
        linetype = "solid",
        colour = colorlist$lt_gray
      ),
      panel.grid.minor = element_blank(),
      axis.title = element_text(
        size = 12,
        colour = colorlist$dk_gray,
        hjust = 0.5
      ),
      axis.line.x = element_line(
        colour = "#000000"
      ),
      axis.line.y = element_blank(),
      axis.text = element_text(
        colour = colorlist$dk_gray,
        size = 12
      ),
      axis.ticks = element_blank(),
      strip.background = element_rect(
        fill = NA,
        colour = NA
      ),
      strip.text = element_text(
        colour = colorlist$dk_gray,
        size = 12
      ),
      panel.background = element_blank(),
      panel.border = element_rect(colour = NA),
      title = element_text(
        face = "plain",
        colour = colorlist$dk_gray,
      ),
      plot.title = element_text(
        size = 20,
        hjust = 0
      ),
      plot.subtitle = element_blank(),
      legend.position = "right",
      legend.text = element_text(
        size = 12,
        colour = colorlist$dk_gray
      ),
      legend.title = element_blank()
    )
}


print(p + theme_gdocs())


