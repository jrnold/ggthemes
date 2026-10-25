# selenized_pal() and theme_selenized() reject unknown values

    Code
      selenized_pal("chartreuse")
    Condition
      Error in `selenized_pal()`:
      ! `accent` must be one of "red", "green", "yellow", "blue", "magenta", "cyan", "orange", or "violet", not "chartreuse".

---

    Code
      selenized_pal(variant = "sepia")
    Condition
      Error in `selenized_pal()`:
      ! `variant` must be one of "light", "dark", "black", or "white", not "sepia".

---

    Code
      theme_selenized(variant = "sepia")
    Condition
      Error in `theme_selenized()`:
      ! `variant` must be one of "light", "dark", "black", or "white", not "sepia".

