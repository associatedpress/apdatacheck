library(tidyverse)
# Look for specific sequences that may indicate an encoding issue
#
# Once we find a suspicious sequence...

# Return data frame where the rows are all of the suspicious rows? (w/ row index)
# If this data frame is empty pass

# NOTE: should we look at byte sequences instead?

# TODO: Fix this regex to correctly catch all keyboard-typable letters
# I think it's the escaping that needs to be done properly
#' Encoding check
#'
#' This function takes in a dataframe and returns rows with characters that
#' denote bad encoding, either using a default list, or allowing user to
#' provide characters to catch.
#'
#'@param df an R dataframe to check
#'@param bad_seq_req A regex of values that denote characters that should not appear
#'with correct encoding
#' @export

encoding_check <- function(df, bad_seq_regex = "[^[`1234567890-=qwertyuiop[]\\asdfghjkl;'zxcvbnm,\\./ ~!@#$%^&*()_+QWERTYUIOP\\{\\}|ASDFGHJKL:\"ZXCVBNM<>?`]]") {
  # 1. Finding the presence of bad sequences in rows in the data frame
  # 2. Return encoding errors
  # Return intersection of column and row where possible error occurs?
  suspect_rows <- df %>%
    mutate(rownumber = row_number()) %>%
    filter_all(any_vars(grepl(bad_seq_regex, .)))

  if(nrow(suspect_rows) > 0) {
    # issue the warning
    suspect_row_string <- paste0(
      "   Row(s): [",
      paste(suspect_rows$rownumber, collapse = ','),
      "]"
    )
    warning(paste("encoding_check: Possible encoding error detected (bad_seqs search):\n",
                  suspect_row_string))
  }
}

test_encoding_check <- function() {
  encoding_check(read_csv("testdata/encoding_check/e_n.csv"))
  encoding_check(read_csv("testdata/encoding_check/incoming_1252.csv"))
  encoding_check(read_csv("testdata/encoding_check/incoming_utf8.csv"))
  encoding_check(read_csv("testdata/encoding_check/roundtrip.csv"))
}

test_encoding_check()

