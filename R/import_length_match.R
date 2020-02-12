
library(readr)
library(stringr)

## Does the length of the raw data file match the length of the data frame?

## The easiest way to check this: count newlines

## We need to be wary of newlines occurring in the middle of quoted fields.

## Note that every row in the data frame must originate from some newline
## character in the file; but not every newline character may line up with a
## new row.

## Also, since the tidyverse is such an essential dependency for us in general,
## let's assume we're using tidyverse functions to import.

## Call out clearly that Excel is not supported; that just leaves the following
## formats:

## .Rdata -- not relevant in this test
## .csv and similar (.tsv, etc)
## Fixed-width files
## The quote problem doesn't appear to manifest with FWFs -- right?

## Note to self: We probably need a very systematized way to do tests and stuff
## Ideally we can just 1. add a test data file and 2. add in expected
## conditions for the test data file.

## Out of scope: rows that are all NA, except for the case where all of those
## occur at the end of the file (?)

## Usability concerns: Do we expect everyone to have a line of code like the
## following:
## `length_match(my_df, "data_file")`
## at the start of all of their analysis projects? How do we make this
## automated? Do we?
## If we try to simplify the semantics to automate like
## `length_match("data_file")`, how do we know that the user properly did it?
## Example -- maybe the user mistakenly skipped the first 2 rows; length_match
## on just the filepath will not notice an issue
## Or do we create some kind of orchestration paradigm for ETL?
## Like, for each file, putting more effort into ETL than we currently do? How
## do we do this tradeoff (between speed/simplicity and rigor)
## A slightly illegal, but viable, way to do this would be to overwrite the
## read_csv function so that it runs at the end. Alternatively, pipes?

## Should we assume all data files end in a new line character?
## Alternatively, we 'soft' hit -- so we build in a tolerance for an end-of-file newline character

## Readr appears to discard all NA rows


#' Length match
#'
#' Function checks that the length of the imported data frame matches the length of
#' the file it was imported from.
#'
#' @param df data frame to check
#' @param filepath path to raw file we imported into data frame
#' @param skip how many lines at the beginning of the file to skip
#' @param col_names if row skipped, if this is true, the new first row is column names, if false, the new first row denotes data values
#' @param verbose if true, output is more comprehensive
#'
#' @export
#'




length_match <- function(df, filepath, skip = 0, col_names = TRUE, verbose = TRUE) {
  ## skip tells the function to skip that many rows before parsing data
  ## Note that col_names = TRUE is the general pattern in tidyverse imports
  ## col_names = TRUE means that, after skipping (if any), the first row is the
  ## header.
  ## col_names = FALSE means that, after skipping, the first row is data
  file_data <- read_file(filepath)
  newlines <- str_count(file_data, "\n") + 1
  # TODO: properly handle quote blocks

  ## Ignore skipped rows and header row
  header_lines <- as.integer(skip) + col_names
  ## Ignore trailing newlines (should we care about newlines at end of file?)
  ## This math is incorrect if files are not assumed to end in newlines
  trailing_blanks <- str_count(str_extract_all(file_data, "\n+$")[[1]], "\n")
  if(length(trailing_blanks) == 0) {
    # This is if trailing_blanks is the empty list; i.e. no trailing blanks
    trailing_blanks <- 0
  }
  ## Ignore newlines within quote blocks
  ## It turns out this is a very dangerous and uncertain zone in terms of
  ## behavior -- so maybe we try our best & just issue a special warning
  ## Tests for presence of quoted newlines
  ## TBD
  ## Counts quoted newlines
  quoted_newlines <- 0 #TBD

  data_rows <- newlines -
    header_lines -
    trailing_blanks -
    quoted_newlines

  if(data_rows != nrow(df)) {
    error_string <-
      paste0(
        "length_match: ", filepath, ":\n",
        "    Raw data file length does not match data frame length")
    error_string_verbose <-
      paste0(
        error_string,
        "\n    ", nrow(df), " row(s) given\n",
        "    ", data_rows, " row(s) found")
    if(verbose) {
      warning(error_string_verbose)
    } else {
      warning(error_string)
    }
  } else {
    message("length_match: ", filepath, ": pass")
  }
  return(df) # Maybe to support piping
}

test_length_match <- function() {
  # Individual tests here

  # label each by what they are testing for
  filepath <- "testdata/length_match/length_match_basic.csv"
  df <- read_csv(filepath, col_types = cols(.default = 'c'))
  length_match(df, filepath)

  filepath <- "testdata/length_match/length_match_extra_newlines.csv"
  df <- read_csv(filepath, col_types = cols(.default = 'c'))
  length_match(df, filepath)

  filepath <- "testdata/length_match/length_match_fwf.txt"
  df <- read_fwf(filepath, fwf_empty(filepath), skip = 1, col_types = cols(.default = 'c'))
  length_match(df, filepath)

  filepath <- "testdata/length_match/length_match_fwf_noheaders.txt"
  df <- read_fwf(filepath, fwf_empty(filepath), col_types = cols(.default = 'c'))
  length_match(df, filepath, col_names = FALSE)

  filepath <- "testdata/length_match/length_match_long_header.csv"
  df <- read_csv(filepath, skip = 2, col_types = cols(.default = 'c'))
  length_match(df, filepath, skip = 2)

  filepath <- "testdata/length_match/length_match_malformed.csv"
  df <- suppressWarnings(read_csv(filepath, col_types = cols(.default = 'c')))
  length_match(df, filepath)

  filepath <- "testdata/length_match/length_match_noheader.csv"
  df <- read_csv(filepath, col_names = FALSE, col_types = cols(.default = 'c'))
  length_match(df, filepath, col_names = FALSE)

  filepath <- "testdata/length_match/length_match_quotes.csv"
  df <- read_csv(filepath, col_types = cols(.default = 'c'))
  length_match(df, filepath)

  filepath <- "testdata/length_match/length_match_quotes2.csv"
  df <- read_csv(v, col_types = cols(.default = 'c'))
  length_match(df, filepath)

  ## read_csv can't do this one correctly!
  filepath <- "testdata/length_match/length_match_combined.csv"
  df <- suppressWarnings(read_csv(filepath, skip = 3, col_types = cols(.default = 'c')))
  length_match(df, filepath, verbose=F)

  invisible() # suppress the return type (is there a better way to do this)
}
