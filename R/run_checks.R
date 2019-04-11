library(tidyverse)
source('R/general-import/check_nas.R')
source('R/general-import/content_spot_check.R')
source('R/general-import/id_grouping.R')
source('R/general-import/length_match.R')
source('R/general-import/multifile_load.R')

# test_check_nas()
# test_content_spot_check()
# test_id_grouping()
# test_multifile_load()
# test_length_match()

filename <- "~/Downloads/shelters.csv"
my_data <- read_csv(filename, n_max = 1000)

check_nas(my_data)

id_grouping(my_data %>% mutate(id = paste(City, state, facility_name, sep='-')), filename, "id")


run_import_checks <- function(dataframe, filename) {
  dataframe %>%
    check_nas() %>%
    length_match() %>%
    your_test_checks_here()
}

run_join_checks <- function(dataframe, left_dataframe, right_dataframe) {

}

run_all_checks <- function(dataframe) {
  dataframe %>%
    run_import_checks() %>%
    run_join_checks()
}
