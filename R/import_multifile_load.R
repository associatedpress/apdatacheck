## Does the data frame correctly load from multiple files we are trying to import?

## Spot check first, last, middle and random lines within a file to make sure they are in our data frame

## Assume we're not counting rows that just contain NAs

## We are assuming all data files have similar number of columns, and names of columns or else they should have errored out before this step

## The test files have columns defined in different order, and this still works

## Also, since the tidyverse is such an essential dependency for us in general,
## let's assume we're using tidyverse functions to import.

library(readr)
library(stringr)
library(tidyverse)
#library(plyr)

#' Checking multifile load
#'
#' What kind of problem are we solving?
#' User claims a column represents dates
#' We want to try to catch and see if it might have been parsed wrong
#' Any invalid dates
#' This function takes in a column that has already been assigned a Date type and
#' checks to see if the entries in that column make sense
#' @export

multifile_load <- function(df, list_of_filenames, skip = 0, col_names = TRUE, verbose=FALSE) {
   total_file_length = 0
   for (filename in list_of_filenames) {
    current_file <- read_csv(filename, col_types = cols(.default = "c"))
    total_file_length <- nrow(current_file) + total_file_length

     first_row <- head(current_file, 1)
     last_row <- tail(current_file, 1)
     middle_row_number <- ceiling(nrow(current_file)/2)
     middle_row <- current_file[middle_row_number,]
     random_row_number <- ceiling(runif(1,1,nrow(current_file)))
     random_row <- current_file[random_row_number,]
     first_row_match <- suppressMessages(semi_join(df, first_row))
     if (length(first_row_match) == 0) {
       warning(paste0(
         "multifile_load: ", filename, ":\n",
         "    First row in file is missing!")
       )
       print(paste("First row in file", filename, 'is missing!'))
     } else {
       if (verbose){
         message(paste0(
           "multifile_load: ", filename, ":\n",
           "    First row in file is in your loaded data.")
         )
       }
     }

     last_row_match <- suppressMessages(semi_join(df, first_row))
     if (length(last_row_match) == 0) {
       warning(paste0(
         "multifile_load: ", filename, ":\n",
         "    Last row in file is missing!")
       )
     } else {
       if (verbose) {
         message(paste0(
           "multifile_load: ", filename, ":\n",
           "    Last row in file matches the loaded data frame.")
         )
       }
     }

     middle_row_match <- suppressMessages(semi_join(df, middle_row))
     if (length(middle_row_match) == 0) {
       warning(paste0(
         "multifile_load: ", filename, ":\n",
         "    Middle row in file is missing!")
       )
     } else {
       if (verbose) {
         message(paste0(
           "multifile_load: ", filename, ":\n",
           "    Middle row in file is in your loaded data frame.")
         )
       }
     }

     random_row_match <- suppressMessages(semi_join(df, random_row))
     if (length(random_row_match) == 0) {
       warning(paste0(
         "multifile_load: ", filename, ":\n",
         "    Random row ", random_row_number, " in file is missing!")
       )
     } else {
       if (verbose){
         message(paste0(
           "multifile_load: ", filename, ":\n",
           "    Random row ", random_row_number, " in file is in your loaded data frame.")
         )      }
     }
  }
   added_file_length_test <- total_file_length == nrow(df)
   if (added_file_length_test == TRUE) {
     if (verbose) {
       message(paste0(
         "multifile_load: ", filename, ":\n",
         "    The lengths of your individual files equal your data frame.")
       )
     }
   } else {
     warning(paste0(
       "multifile_load: ", filename, ":\n",
       "    The lengths of your individual files DO NOT add up to your data frame's length!")
     )
   }
}

test_multifile_load <- function() {
  # Individual tests here
  filelist <- c("testdata/multifile_load/triangle_data.csv", "testdata/multifile_load/square_data.csv")
  df <- filelist %>% map_df(~read_csv(.))
  multifile_load(df, filelist, verbose=TRUE)
  x <- ""

  filelist <- c(
    "testdata/multifile_load/ga_modified.csv",
                "testdata/multifile_load/hi_modified.csv"
                )
  df <- filelist %>% map_df(~read_csv(., col_types = cols(.default = "c")))
  multifile_load(df, filelist, verbose=TRUE)
  x <- ""
}