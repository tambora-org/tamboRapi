#' Install and load multiple packages
#'
#' This function allows you to install and load multiple packages
#' @param pkg list of packages, i.e.   c("jsonlite", "httr")
#' @keywords packages install
#' @export
#' @examples
#' tmbImportPackages(c("jsonlite", "httr"))

tmbImportPackages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}