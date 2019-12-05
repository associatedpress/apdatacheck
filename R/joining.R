source('R/join_check_keys.R')
source('R/join_count_rows.R')

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
