# Are there any leading zeros being dropped off data (ZIP codes!)?
# Is such data being interpreted as strings (ZIP codes should not be numbers)?

#' Checking for leading zeroes
#'
#' What kind of problem are we solving?
#' User claims a column represents dates
#' We want to try to catch and see if it might have been parsed wrong
#' Any invalid dates
#' This function takes in a column that has already been assigned a Date type and
#' checks to see if the entries in that column make sense
#' @export

leading_zero_check <- function(df, filename) {
  # Do you care about trailing zeroes
  # Go through all numeric columns
  # Double check with the _original_ file if any of them have leading zero entries

  # All-character data frame
  file_raw <- read_csv(filename,
                       col_types = cols(.default = 'c'))

  # Getting all numeric columns:
  df_numeric <- df %>%
    select_if(is.numeric) %>%
    mutate_all(as.character)

  # Find mismatches - places where the numeric column disagrees with the original
  suspect_rows <- df_numeric %>%
    mutate(rownumber = row_number()) %>%
    anti_join(file_raw)

  if(nrow(suspect_rows) > 0) {
    # issue the warning
    suspect_col_string <- paste0(
      colnames(suspect_rows %>% select(-rownumber)), collapse = ','
    )
    suspect_row_string <- paste0(
      "\n   Row(s): [",
      paste(suspect_rows$rownumber, collapse = ','),
      "]"
    )
    warning(paste("leading_zero_check: Leading zeroes dropped in column(s):\n",
                  suspect_col_string,
                  suspect_row_string))
  }
}

test_leading_zero_check <- function() {
  leading_zero_check(
    read_csv("testdata/leading_zero_check/zip_codes.csv", guess_max = 1),
    "testdata/leading_zero_check/zip_codes.csv")
  leading_zero_check(
    read_csv("testdata/leading_zero_check/zip_codes_2.csv", guess_max = 1),
    "testdata/leading_zero_check/zip_codes_2.csv")
}
