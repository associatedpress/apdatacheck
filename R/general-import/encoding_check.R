# Look for specific sequences that may indicate an encoding issue
#
# Once we find a suspicious sequence...

# Return data frame where the rows are all of the suspicious rows? (w/ row index)
# If this data frame is empty pass

encoding_check <- function(df, bad_seqs = c("Ã©", "Ã±")) {
  # 1. Finding the presence of bad sequences in rows in the data frame
  # 2. Return encoding errors
  # Return intersection of column and row where possible error occurs?
  suspect_rows <- df %>%
    filter_all(any_vars(grepl(paste(bad_seqs, collapse = "|"), ., ignore.case=T)))
  print(suspect_rows)
  if(nrow(suspect_rows) > 0) {
    # issue the warning
    warning(paste("encoding_check: Possible encoding error detected in rows (bad_seqs search)"))
  }
}

test_encoding_check <- function() {
  encoding_check(read_csv("testdata/encoding_check/e_n.csv"))
  # finalize with the complete set of test files
}

test_encoding_check()

# NOTE: should we look at byte sequences instead?
