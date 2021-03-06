
# This function should have no return; it will be called entirely for its
# warnings
# Is this redundant with check_keys?
#' Counting join rows
#'
#' A concern in a join, particularly the left join, is that the right-hand frame has duplicate rows. This function checks for this by making sure the resulting dataframe has the same number of rows as the left input dataframe.
#'
#' @param left dataframe that we want to merge on the left side of the join
#' @param right dataframe that we want to merge on the right side of the join
#' @param by headers of columns to use to join the left and right data frames
#' @param join_type type of join ('left', right', 'inner', etc.) user is checking
#'
#' @export

count_rows <- function(left, right, by = NULL, join_type) {
  left_rows <- left %>% nrow()
  right_rows <- right %>% nrow()
  if(join_type == "left") {
    # The danger in the left join is that the right-hand frame has duplicate rows
    # the check for this is to make sure the resulting dataframe has the same
    # number of rows as the left input dataframe
    row_count_change <- left %>% left_join(right, by) %>% nrow() - left_rows
  }
  if(join_type == "right") {
    row_count_change <- left %>% right_join(right, by) %>% nrow() - right_rows
  }
  # The filtering joins are both about dropping rows selectively. We will try
  # to report and warn about cases where nothing changes.
  if(join_type == "semi") {
    row_count_change <- left_rows - left %>% semi_join(right, by) %>% nrow()
  }
  if(join_type == "anti") {
    row_count_change <- left_rows - left %>% anti_join(right, by) %>% nrow()
  }

  # Types of returns
  # For left, right joins, strong expectation that nrow is the same
  # For semi, anti joins, mild expectation that nrow should change
  # For full, inner joins, just report change
  if(join_type %in% c("left", "right")) {
    if(row_count_change == 0) {
      message("count_rows: pass")
    } else {
      warning_string <-
        paste0(
          "\ncount_rows: ", paste(by, collapse = ', '), ":\n",
          "    ", row_count_change, " row(s) added after join")
      warning(warning_string)
    }
  }
  if(join_type %in% c("semi", "anti")) {
    if(row_count_change != 0) {
      message("count_rows: pass")
    } else {
      warning_string <-
        paste0(
          "\ncount_rows: ", paste(by, collapse = ', '), ":\n",
          "    No rows were dropped")
      warning(warning_string)
    }
  }
}
# count_rows(mtcars, mtcars, c('mpg', 'hp', 'disp'), 'left')
