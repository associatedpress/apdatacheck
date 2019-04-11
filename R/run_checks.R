library(tidyverse)
source('R/general-import/check_nas.R')
source('R/general-import/content_spot_check.R')
source('R/general-import/id_grouping.R')
source('R/general-import/length_match.R')
source('R/general-import/multifile_load.R')
source('R/joining/check_keys.R')
source('R/joining/count_rows.R')

# test_check_nas()
# test_content_spot_check()
# test_id_grouping()
# test_multifile_load()
# test_length_match()

import_checks <- function(dataframe, filename) {
  dataframe %>%
    length_match(filename)
}

# Join functions -----
# define our new join functions
left_join_dc <- function(left, right, by = NULL, verbose = F) {
  check_keys(left, right, by, verbose)
  count_rows(left, right, by, 'left')
  left_join(left, right, by)
}

right_join_dc <- function(left, right, by = NULL, verbose = F) {
  check_keys(left, right, by, verbose)
  count_rows(left, right, by, 'right')
  right_join(left, right, by)
}

inner_join_dc <- function(left, right, by = NULL, verbose = F) {
  check_keys(left, right, by, verbose)
  count_rows(left, right, by, 'inner')
  inner_join(left, right, by)
}

full_join_dc <- function(left, right, by = NULL, verbose = F) {
  check_keys(left, right, by, verbose)
  count_rows(left, right, by, 'full')
  full_join(left, right, by)
}

semi_join_dc <- function(left, right, by = NULL, verbose = F) {
  check_keys(left, right, by, verbose)
  count_rows(left, right, by, 'semi')
  semi_join(left, right, by)
}

anti_join_dc <- function(left, right, by = NULL, verbose = F) {
  check_keys(left, right, by, verbose)
  count_rows(left, right, by, 'anti')
  anti_join(left, right, by)
}

# Run all checks -----
run_all_checks <- function(dataframe) {
  dataframe %>%
    run_import_checks() %>%
    run_join_checks()
}
