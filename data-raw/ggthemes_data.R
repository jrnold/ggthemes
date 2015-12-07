library("jsonlite")

ggthemes_data <- fromJSON("data-raw/ggthemes_data.json",
                          simplifyDataFrame = FALSE,
                          simplifyMatrix = FALSE)

save(ggthemes_data, file = "data/ggthemes_data.rdata")
