#' Load the data checking functions as well as a high level
#' "run all checks" function.
#' @import tidyverse

# Import checks ----
#' @export
import_checks <- function(dataframe, filename) {
  dataframe %>%
    length_match(filename)
}

# Join functions -----
# define our new join functions
#' @export
left_join_dc <- function(left, right, by = NULL, verbose = F) {
  check_keys(left, right, by, verbose)
  count_rows(left, right, by, 'left')
  left_join(left, right, by)
}

#' @export
right_join_dc <- function(left, right, by = NULL, verbose = F) {
  check_keys(left, right, by, verbose)
  count_rows(left, right, by, 'right')
  right_join(left, right, by)
}

#' @export
inner_join_dc <- function(left, right, by = NULL, verbose = F) {
  check_keys(left, right, by, verbose)
  count_rows(left, right, by, 'inner')
  inner_join(left, right, by)
}

#' @export
full_join_dc <- function(left, right, by = NULL, verbose = F) {
  check_keys(left, right, by, verbose)
  count_rows(left, right, by, 'full')
  full_join(left, right, by)
}

#' @export
semi_join_dc <- function(left, right, by = NULL, verbose = F) {
  check_keys(left, right, by, verbose)
  count_rows(left, right, by, 'semi')
  semi_join(left, right, by)
}

#' @export
anti_join_dc <- function(left, right, by = NULL, verbose = F) {
  check_keys(left, right, by, verbose)
  count_rows(left, right, by, 'anti')
  anti_join(left, right, by)
}

# Run all checks -----
#' @export
run_all_checks <- function(dataframe) {
  dataframe %>%
    run_import_checks() %>%
    run_join_checks()
}
