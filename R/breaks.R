tufte_breaks <- function(data, defaultbreaks=pretty, max_density=0.5) {
    minmax <- c(min(data), max(data))
    def <- defaultbreaks(minmax)
    if (def[1] < minmax[1]) {
        def <- def[-1]
    }
    if (def[length(def)] > minmax[2]) {
        def <- def[-length(def)]
    }
    defdist <- def[2] - def[1]
    if (def[1] - minmax[1] < max_density*defdist) {
        def <- def[-1]
    }
    if (minmax[2] - def[length(def)] < max_density*defdist) {
        def <- def[-length(def)]
    }
    return(sort(c(minmax,def)))
}
