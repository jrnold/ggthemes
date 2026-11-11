# economist_2024_pal reverses and checks its arguments

    Code
      economist_2024_pal(direction = 0)
    Condition
      Error in `economist_2024_pal()`:
      ! `direction` must be 1 or -1, not 0.

---

    Code
      economist_2024_pal()(7)
    Condition
      Warning:
      This palette can handle a maximum of 6 values. You have supplied 7.
    Output
      [1] "#ED1C24" "#F8AB90" "#28479D" "#659BD2" "#636466" "#C6C8CA"

# economist_2024_gradient_pal checks its arguments

    Code
      economist_2024_gradient_pal("blue")
    Condition
      Error in `economist_2024_gradient_pal()`:
      ! `palette` must be one of "red", "gray", or "red-gray", not "blue".

---

    Code
      economist_2024_seq_gradient_pal("red-gray")
    Condition
      Error in `economist_2024_seq_gradient_pal()`:
      ! `palette` must be one of "red" or "gray", not "red-gray".

---

    Code
      economist_2024_div_gradient_pal(direction = 2)
    Condition
      Error in `economist_2024_div_gradient_pal()`:
      ! `direction` must be 1 or -1, not 2.

# economist_2024_chart checks its arguments

    Code
      economist_2024_chart(theme_test_plot(), tab = 1)
    Condition
      Error in `economist_2024_chart()`:
      ! `tab` must be two non-negative numbers: a width and a height.

---

    Code
      economist_2024_chart("plot")
    Condition
      Error in `economist_2024_chart()`:
      ! `plot` must be a ggplot, not a string.

