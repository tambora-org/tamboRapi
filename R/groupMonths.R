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

#help function to calculate fraction of month
fnc_fraction <- function(x) {
  a <- as.numeric(x[["moy"]]);
  b <- as.numeric(x[["b_month"]]);
  e <- as.numeric(x[["e_month"]]);
  r <- 1;
  if (a==floor(b)) {
    r <- 1+a-b;  
  }
  if (a==floor(e)) {
    r <- e-a;  
  }  
  r; 
}

weightMonths <- function(tamboraData) {
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
  # define list of all coverd months of years as moy
  moy <- month_list
  # make list to matrix
  moy <- as.matrix(moy)
  # combine result and tamboraData to tamboraDataMonth
  tamboraDataMonth <- cbind(tamboraData, b_month, e_month, moy)
  # unnesting lists [according to months) to rows
  unnest_data <- unnest(tamboraDataMonth, moy)
  # calculate fraction respectively weighting for each month
  unnest_data$time_weight <- apply(unnest_data, 1, fnc_fraction)
  # get all covered months in year (range:1-12)
  unnest_data$moy <- unnest_data$moy %% 12 + 1
  # return value
  unnest_data
}