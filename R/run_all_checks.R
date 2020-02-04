#' Load the data checking functions as well as a high level
#' "run all checks" function.
#' @import tidyverse

# Import checks ----
#' Import checks
#'
#' What kind of problem are we solving?
#' User claims a column represents dates
#' We want to try to catch and see if it might have been parsed wrong
#' Any invalid dates
#' This function takes in a column that has already been assigned a Date type and
#' checks to see if the entries in that column make sense
#' @export

import_checks <- function(dataframe, filename) {
  dataframe %>%
    length_match(filename)
}

# Join functions -----
# define our new join functions
#' Join check
#'
#' What kind of problem are we solving?
#' User claims a column represents dates
#' We want to try to catch and see if it might have been parsed wrong
#' Any invalid dates
#' This function takes in a column that has already been assigned a Date type and
#' checks to see if the entries in that column make sense
#' @export
left_join_dc <- function(left, right, by = NULL, verbose = F) {
  check_keys(left, right, by, verbose)
  count_rows(left, right, by, 'left')
  left_join(left, right, by)
}

#' Join checks
#'
#' What kind of problem are we solving?
#' User claims a column represents dates
#' We want to try to catch and see if it might have been parsed wrong
#' Any invalid dates
#' This function takes in a column that has already been assigned a Date type and
#' checks to see if the entries in that column make sense
#' @export
right_join_dc <- function(left, right, by = NULL, verbose = F) {
  check_keys(left, right, by, verbose)
  count_rows(left, right, by, 'right')
  right_join(left, right, by)
}

#' Join checks
#'
#' What kind of problem are we solving?
#' User claims a column represents dates
#' We want to try to catch and see if it might have been parsed wrong
#' Any invalid dates
#' This function takes in a column that has already been assigned a Date type and
#' checks to see if the entries in that column make sense
#' @export
inner_join_dc <- function(left, right, by = NULL, verbose = F) {
  check_keys(left, right, by, verbose)
  count_rows(left, right, by, 'inner')
  inner_join(left, right, by)
}

#' Join checks
#'
#' What kind of problem are we solving?
#' User claims a column represents dates
#' We want to try to catch and see if it might have been parsed wrong
#' Any invalid dates
#' This function takes in a column that has already been assigned a Date type and
#' checks to see if the entries in that column make sense
#' @export
full_join_dc <- function(left, right, by = NULL, verbose = F) {
  check_keys(left, right, by, verbose)
  count_rows(left, right, by, 'full')
  full_join(left, right, by)
}

#' Join checks
#'
#' What kind of problem are we solving?
#' User claims a column represents dates
#' We want to try to catch and see if it might have been parsed wrong
#' Any invalid dates
#' This function takes in a column that has already been assigned a Date type and
#' checks to see if the entries in that column make sense
#' @export
semi_join_dc <- function(left, right, by = NULL, verbose = F) {
  check_keys(left, right, by, verbose)
  count_rows(left, right, by, 'semi')
  semi_join(left, right, by)
}

#' Join checks
#'
#' What kind of problem are we solving?
#' User claims a column represents dates
#' We want to try to catch and see if it might have been parsed wrong
#' Any invalid dates
#' This function takes in a column that has already been assigned a Date type and
#' checks to see if the entries in that column make sense
#' @export
anti_join_dc <- function(left, right, by = NULL, verbose = F) {
  check_keys(left, right, by, verbose)
  count_rows(left, right, by, 'anti')
  anti_join(left, right, by)
}

# Run all checks -----
#' Run all checks
#'
#' What kind of problem are we solving?
#' User claims a column represents dates
#' We want to try to catch and see if it might have been parsed wrong
#' Any invalid dates
#' This function takes in a column that has already been assigned a Date type and
#' checks to see if the entries in that column make sense
#' @export
run_all_checks <- function(dataframe) {
  dataframe %>%
    run_import_checks() %>%
    run_join_checks()
}
