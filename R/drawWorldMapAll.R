source("R/tmbImportPackages.R")

installMapDrawPackages <- function() {
  # define needed packages
  packages <- c("extrafont", "ggmap", "ggplot2")
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

drawWorldMapAll <- function(tamboraData) {
  installMapDrawPackages()
  bbox <- make_bbox(lon = tamboraData$x, lat = tamboraData$y, f = 0.05)

  # create a layer of borders
  mp <- NULL
  mapWorld <- borders("world", colour="#6F9BC5", fill="#6F9BC5")
  mp <- ggplot() +   mapWorld

  #plot now layer of events on top
  mp <- mp+ geom_point(aes(x=tamboraData$x, y=tamboraData$y) ,color="#F08219", size=2, shape=20)+
    labs(fill="")+
    theme(legend.position="right", text=element_text(size=14, family="Calibri")) 
  mp  
}
