require("ggplot2")
if (require("tidyr") && require("dplyr")) {
  rescale01 <- function(x) {
    (x - min(x)) / diff(range(x))
  }

  gather(economics, variable, value, -date) %>%
    group_by(variable) %>%
    mutate(value = rescale01(value)) %>%
    ggplot(aes(x = date, y = value, linetype = variable)) +
    geom_line() +
    scale_linetype_stata()
}
