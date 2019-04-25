# library(tidyverse)
#
# ##let’s look for words that include ‘total’ or like statements
# total_words <- data.frame("Total", "total", "TOTAL", "SUM", "Sum", "sum")
#
# check_for_totals <- function {
#   data %>%
#     filter_all(any_vars(str_detect(., total_words)))
# }
#
# ## beyond that, does a numerical value equal the sums of all the others?
# Should we assume this function is run only after we've 'cleaned' the data
# with regards to what columns are what type and what the raw data represents?


total_check <- function(df, keywords = c("subtotal", "total", "sum")) {
  # 1. Finding the presence of key words in rows in the data frame

  suspect_rows <- df %>%
    filter_all(any_vars(grepl(paste(keywords, collapse = "|"), ., ignore.case=T)))
  if(nrow(suspect_rows) > 0) {
    # issue the warning
    warning("Totals detected as rows (keyword search)")
  }

  # 2. Doing some numerical search - are any rows apparently a total of other rows
  # 2.1 If you sort it and the 'largest' row is substantially bigger

  # Working only within numerical columns
  #
  #  - sort it
  #  - skim off top row
  #  - check if it's
  #    - really big?
  #    - the sum of all the others

  # Question: how do we handle it if there are multiple 'total' rows that are identical?
  # (see: testdata/total_check/multiple_totals.csv)
}

test_total_check <- function() {
  total_check(read_csv("testdata/total_check/test.csv"))
  total_check(read_csv("testdata/total_check/subtotal.csv"))
  total_check(read_csv("testdata/total_check/hidden_name.csv"))
  total_check(read_csv("testdata/total_check/check_type.csv"))
}

test_total_check()



# mtcars %>%
#   group_by(mpg == max(mpg)) %>%
#   summarize(total = sum(mpg))
