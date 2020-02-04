library(tidyverse)

# Like other join checks, we don't return any type here, just messages
#' Checking join keys
#'
#' What kind of problem are we solving?
#' User claims a column represents dates
#' We want to try to catch and see if it might have been parsed wrong
#' Any invalid dates
#' This function takes in a column that has already been assigned a Date type and
#' checks to see if the entries in that column make sense
#' @export

check_keys <- function(left, right, by = by, verbose = F, join_type = "left") {
  left_nondistinct <- left %>% count_(by) %>% filter(n > 1)
  right_nondistinct <- right %>% count_(by) %>% filter(n > 1)
  left_primary_key_valid <- nrow(left_nondistinct) == 0
  right_primary_key_valid <- nrow(right_nondistinct) == 0

  warning_string <-
    paste0(
      "\ncheck_keys: ", by, ":\n",
      "    Key given is not a primary key")
  if(join_type == "left") {
    warning_string_verbose <-
      paste0(
        warning_string,
        "\n    Right: ", nrow(right_nondistinct), " nondistinct row(s)"
      )
  }
  if(join_type == "right") {
    warning_string_verbose <-
      paste0(
        warning_string,
        "\n    Left: ", nrow(left_nondistinct), " nondistinct row(s)"
      )
  }
  if(join_type == "full") {
    warning_string_verbose <-
      paste0(
        warning_string,
        "\n    Left: ", nrow(left_nondistinct), " nondistinct row(s)\n",
        "    Right: ", nrow(right_nondistinct), " nondistinct row(s)"
      )
  }
  if(left_primary_key_valid & join_type == "right" |
     right_primary_key_valid & join_type == "left") {
    message("check_keys: pass")
  } else {
    if(verbose) {
      warning(warning_string_verbose)
    } else {
      warning(warning_string)
    }
  }
}

# Tests:
# Check the keys are actually in the dang df
# Check the dfs aren't null
# check_keys(mtcars, mtcars, c("mpg", "hp"))
