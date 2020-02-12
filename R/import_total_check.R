# library(tidyverse)
#
# ##let’s look for words that include ‘total’ or like statements
# total_words <- data.frame("Total", "total", "TOTAL", "SUM", "Sum", "sum")
#
# check_for_totals <- function {
#   data %>%
#     filter_all(any_vars(str_detect(., total_words)))
# }
#
# ## beyond that, does a numerical value equal the sums of all the others?
# Should we assume this function is run only after we've 'cleaned' the data
# with regards to what columns are what type and what the raw data represents?


check_column_for_outlier <- function(column, threshold) {
  suspect_rows <- column %>%
    data.frame() %>%
    mutate(standardized = scale(column)) %>%
    filter(standardized > threshold)

  return(nrow(suspect_rows) > 0)
}

#' Total check
#'
#' This function returns rows and columns that might be total rows, and
#' possibly should be separated from the dataset.
#'
#' @param df dataframe we are checking
#' @param keywords words denoting rows with totals or sums we are trying to check for
#' @param threshold maximum of how many times finding the above keywords in the dataset is expected
#'
#' @export

total_check <- function(df, keywords = c("subtotal", "total", "sum"), threshold = 4) {
  # 1. Finding the presence of key words in rows in the data frame

  suspect_rows <- df %>%
    filter_all(any_vars(grepl(paste(keywords, collapse = "|"), ., ignore.case=T)))
  if(nrow(suspect_rows) > 0) {
    # issue the warning
    warning("total_check: Totals detected as rows (keyword search)")
  }

  # 2. Detecting totals/subtotals by looking at how much of an outlier they are
  # Data.world's strategy: are there any rows that are N many standard
  # deviations above the mean? Flag them

  numeric_columns <- df %>%
    select_if(is.numeric)

  if(ncol(numeric_columns) != 0) {
    suspect_columns <- df %>%
      select_if(is.numeric) %>%
      apply(2, function(x) {check_column_for_outlier(x, threshold)})

    if(reduce(suspect_columns, `|`)) {
      warning("total_check: Outlier found more than ", threshold, " standard deviations above")
    }
  }
}

test_total_check <- function() {
  total_check(read_csv("testdata/total_check/test.csv"))
  total_check(read_csv("testdata/total_check/subtotal.csv"))
  total_check(read_csv("testdata/total_check/check_type.csv"))
  total_check(read_csv("testdata/total_check/PEP_2018_PEPANNRES.csv"))
}

test_total_check()
