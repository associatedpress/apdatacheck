# check for missing data
# confirm if real values
# ---
# What we'll produce:
# A 'column report', that says what % of a col are NA/blank
# Theres probably significant performance improvements?
# 1. The for loop
# 2. The way we stitch together the results from the for loop
# Helper function to make the checks themselves look cleaner
#' Checking for nas or missing data
#'
#' The function summarizes how many values are either missing or blank and reports
#' that to user. Optionally, user can provide a test function which can check for additional missing values
#' this test_function should return true for a value if it should be flagged as missing or empty
#'
#'@param working_col column to check for missing data
#'@param test_function function which returns true to identify a cell of data as "missing"
#' @export

check_column <- function(working_col, test_function) {
  result_scaffold <-
    data.frame(flag = c(TRUE, FALSE))

  working_col %>%
    count(flag = test_function(label)) %>%
    right_join(result_scaffold, by = "flag") %>%
    mutate(n = ifelse(is.na(n), 0, n)) %>%
    filter(flag) %>%
    .$n
}

check_nas <- function(df) {
  results <- data.frame()

  for (column in colnames(df)) {
    working_col <-
      df %>%
      select(label = column)

    # 1. number of NAs
    n_na <-
      working_col %>%
      check_column(function(x) {is.na(x)})

    # 2. number of non-finite values (NA, NaN, Inf, etc.)
    n_non_finite <-
      working_col %>%
      check_column(function(x) {!is.finite(x)})

    n_zero <-
      working_col %>%
      check_column(function(x) {x == 0})

    n_blank <-
      working_col %>%
      check_column(function(x) {gsub(" *", "", x) == ""})

    n_na_string <-
      working_col %>%
      check_column(function(x) {trimws(toupper(x)) == "NA"})

    n_zero_string <-
      working_col %>%
      check_column(function(x) {trimws(x) == "0"})

    n_punct_only <-
      working_col %>%
      check_column(function(x) {gsub("[[:punct:]]", "", x) == ""})

    result_row <-
      data.frame(column, n_na, n_non_finite, n_zero, n_blank, n_na_string, n_zero_string, n_punct_only)

    results <-
      rbind(results, result_row)
  }
  results
}

test_check_nas <- function() {
  filename <- "testdata/check_nas/check_nas_1.csv"
  df <- read_csv(filename)
  check_nas(df) %>%
    print
}
