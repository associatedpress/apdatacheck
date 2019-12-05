#' What kind of problem are we solving?
#' User claims a column represents dates
#' We want to try to catch and see if it might have been parsed wrong
#' Any invalid dates
#'
#' This function takes in a column that has already been assigned a Date type and
#' checks to see if the entries in that column make sense
#' Todo:
#' Fix output warning formatting to be in the same style as the rest of datacheck
#' Fix quasiquotation for passing in columns as arguments
#' Possibly implement some kind of outlier detection for dates?
#' @export
date_check <- function(df, col, check_future=T, date_blacklist=as.Date(c("1899-12-31", "1900-01-01", "1901-01-01", "1904-01-02", "9999-09-09")), valid_date_range = c(1970, 2050)) {
  df <- df %>% mutate(row_number = row_number())
  # 1.1 check for suspicious days
  suspicious_dates <- max(day(df$col), na.rm=T) < 13
  if(suspicious_dates) {
    warning("Possible month and day swap")
  }
  # 1.2 are there lots of days like Jan. 1? Dec. 25?
  # TBD
  # 2. check for suspicious years
  # 2.1. explicit blacklist for years that are extremely suspicious
  # Jan. 1, 1900; Dec. 31, 1899; Jan. 2, 1904
  # Year 9999, year 0000, year 0
  suspicious_rows <-
    df %>%
    filter(col %in% date_blacklist)

  if(nrow(suspicious_rows) > 1) {
    # fill this in later with standard warning outputs
    # output: row number and suspicious dates
    warning("Suspicious dates found")
  }

  # 2.2. 'reasonableness' bound: anything before 1970 and anything after 2050 should merit a warning
  suspicious_rows <-
    df %>%
    filter(!between(year(col), valid_date_range[1], valid_date_range[2]))

  if(nrow(suspicious_rows) > 1) {
    warning("Years outside bounds") ## change this later
  }

  # 2.2a. check for dates that happen in the future? (are you assuming your date column only involves events in the past)
  if(check_future) {
    suspicious_rows <-
      df %>%
      filter(col > Sys.Date())

    if(nrow(suspicious_rows) > 1) {
      # output warnings
      warning("Future dates detected")
    }
  }

  # 2.3. statistical test for unusual years? like 5555? or 1700?

  # for example - check the typical frequency of years in the data set and flag
  # years that show up either way too much or hardly at all

  # unresolved question about sensitivity
}

#' @export
test_date_check <- function() {
  # df <- read_csv("testdata/date_check/data_check_dams_sample.csv", col_types = 'cccccc') %>%
  #   mutate(inspection_date = as.Date(inspection_date), eap_revision_date = as.Date(eap_revision_date))
  df <- read_csv("testdata/date_check/data_check_dams_sample.csv")

  # todo: fix quasiquotation issue with passing column names as a function argument
  df %>%
    date_check(inspection_date)
}
