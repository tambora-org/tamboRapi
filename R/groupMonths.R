source("R/tmbImportPackages.R")

installGroupPackages <- function() {
  # define needed packages
  packages <- c("tidyverse")
  tmbImportPackages(packages)
}

# get all covered months of an absolute time intervall
rangeOfMonths <- function(x) floor(x[["b_month"]]):floor(x[["e_month"]])

# get all covered months in year (range:1-12)
indexOfMonth <- function(x) x %% 12 + 1

# calculate all covered months of a tambora.org dataset
groupMonths <- function(tamboraData) {
  installGroupPackages()
  # define absolute time interval
  b <- interval(ymd("0000-01-01"), tamboraData$begin_timestamp)
  e <- interval(ymd("0000-01-01"), tamboraData$end_timestamp)
  # convert time interval to months
  b_month <- b / months(1)
  e_month <- e / months(1)
  # combine to begin and end to one list
  l_months <- cbind(b_month, e_month)
  # list of all covered months
  month_list <- apply(l_months, 1, rangeOfMonths)
  # list of all coverd months of years
  moy <- sapply(month_list, indexOfMonth)
  # make list to matrix
  moy <- as.matrix(moy)
  # combine result and tamboraData to tamboraDataMonth
  tamboraDataMonth <- cbind(tamboraData, moy)
  
  # return value
  tamboraDataMonth 
}
	
