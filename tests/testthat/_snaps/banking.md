# bank_slopes with invalid method throws error

    Code
      bank_slopes(1:5, 1:5, method = "aor")
    Condition
      Error in `bank_slopes()`:
      ! `method` must be one of "ms", "as", "ao", or "was", not "aor".
      i Did you mean "ao"?

# bank_plot errors for an out-of-range layer index

    Code
      bank_plot(p, layer = 2)
    Condition
      Error in `bank_plot()`:
      ! `layer` must be at most 1, the number of layers in `plot`, not 2.

# bank_plot errors for a non-positive layer index

    Code
      bank_plot(p, layer = 0)
    Condition
      Error in `bank_plot()`:
      ! `layer` must be a whole number larger than or equal to 1, not the number 0.

---

    Code
      bank_plot(p, layer = -1)
    Condition
      Error in `bank_plot()`:
      ! `layer` must be a whole number larger than or equal to 1, not the number -1.

# bank_plot errors when the layer has no x/y columns

    Code
      check_bank_plot_data(data.frame(xmin = 1:3, xmax = 2:4))
    Condition
      Error in `check_bank_plot_data()`:
      ! The layer data is missing required column(s): x and y.
      i `bank_plot()` needs both x and y.

# bank_plot() requires a ggplot and a whole-number layer

    Code
      bank_plot("not a plot")
    Condition
      Error in `bank_plot()`:
      ! `plot` must be a ggplot object, not a string.

---

    Code
      bank_plot(p, layer = 1.5)
    Condition
      Error in `bank_plot()`:
      ! `layer` must be a whole number, not the number 1.5.

