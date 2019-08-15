# If data has individual categories, look at list of all categories,
# and make sure none are being excluded because of casing/spelling issues

# We should ask the user for the column we want to check out
# For now let's use column name as string

# Strategy:
# Group up the values in the column - that's our reference
# Group up the values after doing some type of standardization to the column

# Examples:
# 1. Removing spaces
# 1.1 Removing spaces from the end (trimming ws)
# 1.2 Removing spaces from the whole entry
# 1.3 Removing spaces from the beginning
# 2. Standardized capitalization - all lowercase

# Possible extensions:
# Fuzzy matching, checking for typos, handling punctuation of all types,
# Replace numbers with just ["#"] or some other alias

# To extend this function to other standardizations, modify the contents of the
# mutate statement
category_check <- function(df, col_name) {
  # Base case
  column_of_interest <- df %>% count(!!(enquo(col_name)))
  # "standardized" columns:
  suspect_categories <- df %>%
    distinct(!!(enquo(col_name))) %>%
    mutate(
      # To extend this function, add new standardization steps here
      trimspaces = trimws(!!(enquo(col_name))),
      nopunctuation = gsub("[[:punct:]]", "", !!(enquo(col_name))),
      nospaces = gsub(" ", "", !!(enquo(col_name)))
      ) %>%
    group_by(trimspaces) %>%
    mutate(trimspacecount = n()) %>%
    group_by(nopunctuation) %>%
    mutate(nopunctuationcount = n()) %>%
    group_by(nospaces) %>%
    mutate(nospacecount = n()) %>%
    # Add a group by and counting step here for any standardization here
    filter_if(is.numeric, any_vars(. > 1))
  if(nrow(suspect_categories) > 0) {
    warning("category_check: After standardization, these categories overlap:\n",
            paste0("`", suspect_categories[,1, drop = TRUE], "`", collapse = ', '))
  }
}

test_category_check <- function() {
  test_data <- read_csv("testdata/category_check/spaces1.csv", col_types = cols(.default = 'c'), trim_ws = FALSE)
  category_check(test_data, Category)
}
