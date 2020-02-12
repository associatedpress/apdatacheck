library(dplyr)
library(readr)

#' Id grouping check
#'
#'Params
#'df = data frame to test
#'filepath = path to file that was imported, for comparison
#'id_column = name of the column with ids we expect to be unique
#'verbose = how extensive output of grouping function should be
#'
#'Function returns warning if ids to group by are duplicated
#' @export

id_grouping <- function(df, filepath, id_column, verbose=FALSE) {
  grouped_ids <- df %>% group_by_(id_column) %>% summarize(count = n())
  number_of_ids <- nrow(grouped_ids)
  duped_ids <- grouped_ids %>% filter(count != 1)
  if (nrow(duped_ids) != 0) {
  warning(paste0(
    "id_grouping: ", filepath, ":\n",
    "    You have ", nrow(duped_ids), " duplicated ids which are ", duped_ids %>% select_(id_column))
  )
  } else {
    message(paste0(
      "id_grouping: ", filepath, ":\n",
      "    All ", number_of_ids, " ids are unique!")
    )
  }
}

test_id_grouping <- function() {
  # Individual tests here
  filepath <- "testdata/id_grouping/mi_dams_data.csv"
  df <- read_csv(filepath)
  id_grouping(df, filepath, "NAT_ID", verbose=TRUE)

  filepath <- "testdata/id_grouping/mi_dams_data_dupes.csv"
  df <- read_csv(filepath)
  id_grouping(df, filepath, "NAT_ID", verbose=TRUE)

  x <- ""
}
