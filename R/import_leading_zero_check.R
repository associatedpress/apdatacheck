# Are there any leading zeros being dropped off data (ZIP codes!)?
# Is such data being interpreted as strings (ZIP codes should not be numbers)?

#' Leading zero check
#'
#'Function accesses columns with numeric input and checks for rows where
#'the numbers in columns don't match between the raw file and the dataframe,
#'this denotes where leading zeroes are not carried over from the raw file
#'to the dataframe.
#'
#' @param df data frame to check
#' @param filepath path to raw file we imported into data frame
#'
#' @export

leading_zero_check <- function(df, filepath) {
  # Do you care about trailing zeroes
  # Go through all numeric columns
  # Double check with the _original_ file if any of them have leading zero entries

  # All-character data frame
  file_raw <- read_csv(filepath,
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
