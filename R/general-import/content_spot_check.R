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

content_spot_check <- function(df, filename, delim = ',', rows = 15, skip = 0, verbose = T) {
  #  filename <- "testdata/content_spot_check/content_spot_check_long_header.csv"
  #  df <- iris
  #  skip = 2
  #  df <- data.frame()
  # Manual parsing
  data <- strsplit(read_file(filename), '\n')[[1]]
  if (length(data) == 0) {
    error_string <-
      paste0(
        "content_spot_check: ", filename, ":\n",
        "    Empty file")

    warning(error_string)
    return(df)
  }
  if (length(data) <= skip + 1) {
    error_string <-
      paste0(
        "content_spot_check: ", filename, ":\n",
        "    Only header found")
    warning(error_string)
    return(df)
  }
  row_limit <- rows > (length(data) - skip - 1)
  rows <- min(rows, length(data) - skip - 1)
  if (row_limit & verbose) {
    error_string <-
      paste0(
        "content_spot_check: ", filename, ":\n",
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
        "content_spot_check: ", filename, ":\n",
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
          "content_spot_check: ", filename, ": pass")
      warning(error_string)
    } else {
      # failed
      error_string <-
        paste0(
          "content_spot_check: ", filename, ":\n",
          "    Row mismatch")
      warning(error_string)
    }
  }
}

test_content_spot_check <- function() {
  # Individual tests here

  # label each by what they are testing for
  filename <- "testdata/content_spot_check/content_spot_check_empty_file.csv"
  df <- data.frame()
  content_spot_check(df, filename)

  filename <- "testdata/content_spot_check/content_spot_check_just_header.csv"
  df <- read_csv(filename, col_types = cols(.default = 'c'))
  content_spot_check(df, filename)

  filename <- "testdata/content_spot_check/content_spot_check_short_file.csv"
  df <- read_csv(filename, col_types = cols(.default = 'c'))
  content_spot_check(df, filename)

  filename <- "testdata/content_spot_check/content_spot_check_normal_file.csv"
  df <- iris
  content_spot_check(df, filename)

  # Now we intentionally mangle our df:
  # Drop a row
  df <- iris[c(1:10, 12:150),]
  content_spot_check(df, filename)

  # Drop a column
  df <- iris[, 1:3]
  content_spot_check(df, filename)

  invisible() # suppress the return type (is there a better way to do this)
}
