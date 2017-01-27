source("R/tmbImportPackages.R")

installDrawPackages <- function() {
  # define needed packages
  packages <- c("extrafont", "ggplot2")
  tmbImportPackages(packages)
}

#' Draw summary of all tambora data to a map
#'
#' This function allows you to draw data inquired from tambora.org to a map
#' @param tamboraData, i.e. as inquired by function fromTambora()
#' @keywords tambora.org map visualisation
#' @export
#' @examples
#' data<-fromTambora(); drawWorldMapAll(data)

drawYearHistogramm <- function(tamboraData) {
  installDrawPackages()
  ggplot(tamboraData, aes(begin_year)) + geom_histogram(color = "#6F9BC5", fill = "#6F9BC5", binwidth = 0.5)
}
