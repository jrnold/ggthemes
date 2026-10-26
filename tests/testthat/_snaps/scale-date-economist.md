# scale_x_date_economist refuses breaks it would override

    Code
      scale_x_date_economist(breaks = NULL)
    Condition
      Error in `scale_x_date_economist()`:
      ! `scale_x_date_economist()` sets its breaks from the axis layout, so `breaks` can't be given.
      i Use `ggplot2::scale_x_date(guide = guide_axis_economist_date())` to choose other breaks.

---

    Code
      scale_x_date_economist(minor_breaks = NULL)
    Condition
      Error in `scale_x_date_economist()`:
      ! `scale_x_date_economist()` sets its breaks from the axis layout, so `minor_breaks` can't be given.
      i Use `ggplot2::scale_x_date(guide = guide_axis_economist_date())` to choose other breaks.

