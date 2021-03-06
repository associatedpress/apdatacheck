## I decided to make it 15 by default, but configurable how many rows
## If more rows for spot checking are sought then rows in the data then we warn
## and self-limit
## We also inherit the delimiter logic (but use only 'raw' read_file)

## Test cases:
## Short file
## Empty file?
## Incorrect row
## Column mismatch

library(readr)
#' Spot checking content
#'
#' This is a generic function that performs several quick checks on a dataset
#' to check for discrepancies versus the originating file. Function will return messages warning against mismatched length between the R dataframe and the original file,
#'or if rows or columns are mismatched between the raw data file and the R dataframe
#' @param df dataframe user wants to test
#' @param filepath path to file of raw data user wants to compare
#' @param delim character used to break up cells in data file
#' @param rows number of rows to use to test file, default is 15
#' @param skip number of rows to skip at top of the file if needed
#' @param verbose if true, returns more comprehensive output
#' @export

content_spot_check <- function(df, filepath, delim = ',', rows = 15, skip = 0, verbose = T) {
  #  filepath <- "testdata/content_spot_check/content_spot_check_long_header.csv"
  #  df <- iris
  #  skip = 2
  #  df <- data.frame()
  # Manual parsing
  data <- strsplit(read_file(filepath), '\r\n')[[1]]
  if (length(data) == 0) {
    error_string <-
      paste0(
        "content_spot_check: ", filepath, ":\n",
        "    Empty file")

    warning(error_string)
    return(df)
  }
  if (length(data) <= skip + 1) {
    error_string <-
      paste0(
        "content_spot_check: ", filepath, ":\n",
        "    Only header found")
    warning(error_string)
    return(df)
  }
  row_limit <- rows > (length(data) - skip - 1)
  rows <- min(rows, length(data) - skip - 1)
  if (row_limit & verbose) {
    error_string <-
      paste0(
        "content_spot_check: ", filepath, ":\n",
        "    Fewer rows found to spot check than expected")
    warning(error_string)
  }
  header <- strsplit(data[skip + 1], delim)[[1]]
  sample_data <- data.frame(t(data.frame(strsplit(data, delim)))[(1 + skip) + 1:(rows),])
  colnames(sample_data) <- header
  rownames(sample_data) <- 1:rows

  # Most clear check first:
  if (ncol(sample_data) != ncol(df)) {
    # Warning here, ignore the rest of the file
    error_string <-
      paste0(
        "content_spot_check: ", filepath, ":\n",
        "    Column mismatch")
    warning(error_string)
  } else {
    testFlag <- TRUE
    for(row_index in 1:rows) {
      row_score <- sum(sample_data[row_index,] == df[row_index,])
      testFlag <- testFlag * (row_score == ncol(sample_data))
    }
    if (testFlag) {
      error_string <-
        paste0(
          "content_spot_check: ", filepath, ": pass")
      warning(error_string)
    } else {
      # failed
      error_string <-
        paste0(
          "content_spot_check: ", filepath, ":\n",
          "    Row mismatch")
      warning(error_string)
    }
  }
}

test_content_spot_check <- function() {
  # Individual tests here

  # label each by what they are testing for
  filepath <- "testdata/content_spot_check/content_spot_check_empty_file.csv"
  df <- data.frame()
  content_spot_check(df, filepath)

  filepath <- "testdata/content_spot_check/content_spot_check_just_header.csv"
  df <- read_csv(filepath, col_types = cols(.default = 'c'))
  content_spot_check(df, filepath)

  filepath <- "testdata/content_spot_check/content_spot_check_short_file.csv"
  df <- read_csv(filepath, col_types = cols(.default = 'c'))
  content_spot_check(df, filepath)

  filepath <- "testdata/content_spot_check/content_spot_check_normal_file.csv"
  df <- iris
  content_spot_check(df, filepath)

  # Now we intentionally mangle our df:
  # Drop a row
  df <- iris[c(1:10, 12:150),]
  content_spot_check(df, filepath)

  # Drop a column
  df <- iris[, 1:3]
  content_spot_check(df, filepath)

  invisible() # suppress the return type (is there a better way to do this)
}
