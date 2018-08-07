## Does the data frame correctly load from multiple files we are trying to import?

## Spot check first, last, middle and random lines within a file to make sure they are in our data frame

## Assume we're not counting rows that just contain NAs

## We are assuming all data files have similar number of columns, and names of columns or else they should have errored out before this step


## Also, since the tidyverse is such an essential dependency for us in general,
## let's assume we're using tidyverse functions to import.

library(readr)
library(stringr)
library(tidyverse)
library(plyr)

multifile_load <- function(df, list_of_filenames, skip = 0, col_names = TRUE) {
  total_file_length = 0
  for (filename in list_of_filenames) {
    current_file <- read_csv(filename)
    total_file_length <- nrow(current_file) + total_file_length

    first_row <- head(current_file, 1)
    last_row <- tail(current_file, 1)
    middle_row_number <- ceiling(nrow(current_file)/2)
    middle_row <- current_file[middle_row_number,]
    random_row_number <- ceiling(runif(1,1,nrow(current_file)))
    random_row <- current_file[random_row_number,]
    first_row_match <- match_df(df, first_row)
    if (length(first_row_match) == 0) {
      print(paste("First row in file", filename, 'is missing!'))
    } else {
      print(paste("First row in file", filename, 'is in your loaded data!'))
    }

    last_row_match <- match_df(df, first_row)
    if (length(last_row_match) == 0) {
      print(paste("Last row in file", filename, 'is missing!'))
    } else {
      print(paste("Last row in file", filename, 'is in your loaded data!'))
    }

    middle_row_match <- match_df(df, middle_row)
    if (length(middle_row_match) == 0) {
      print(paste("Middle row in file, (row", middle_row_number, ") ", filename, 'is missing!'))
    } else {
      print(paste("Middle row in file, (row", middle_row_number, ") ", filename, 'is in your loaded data!'))
    }

    random_row_match <- match_df(df, random_row)
    if (length(random_row_match) == 0) {
      print(paste("Random row in file, (row", random_row_number, ") ", filename, 'is missing!'))
    } else {
      print(paste("Random row in file, (row", random_row_number, ") ", filename, 'is in your loaded data!'))
    }
  }
  added_file_length_test <- total_file_length == nrow(df)
  if (added_file_length_test == TRUE) {
    print("Your file lengths match!")
  } else {
    print('Watch out! The lengths of your individual files DO NOT EQUAL your data frame')
  }





}

test_multifile_load <- function() {
  # Individual tests here
  filelist <- c("testdata/multifile_load/triangle_data.csv", "testdata/multifile_load/square_data.csv")
  df <- filelist %>% map_df(~read_csv(.))
  multifile_load(df, filelist)
  x <- ""
}

test_multifile_load()
