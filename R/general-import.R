source('R/general-import/check_nas.R')
source('R/general-import/content_spot_check.R')
source('R/general-import/id_grouping.R')
source('R/general-import/length_match.R')
source('R/general-import/multifile_load.R')

import_checks <- function(dataframe, filename) {
  dataframe %>%
    length_match(filename)
}
