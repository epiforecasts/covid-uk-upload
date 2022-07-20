library("here")
library("readr")
library("dplyr")

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  stop("At least one argument must be supplied (input file).n", call. = FALSE)
}

input_file <- args[1]
exclusions <- read_csv(here::here("data/r-exclusions.csv"))

r <- read_csv(input_file) %>%
  anti_join(exclusions, by = c("Geography", "Model"))

write_csv(r, input_file)
