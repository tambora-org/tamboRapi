source("R/tmbImportPackages.R")

installDrawPackages <- function() {
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

drawIndexBoxPlot <- function(tamboraData) {
  installDrawPackages()
 
  #create subset of column realy needed, here value_index and begin_year
  value_year <- tamboraData[,c('value_index', 'begin_year')]

  #keep only complete rows with full entries for subset
  value_year <- value_year[complete.cases(value_year),]
  #Make sure that value_index is double type for mean calculation without rounding
  value_year$value_index <- as.double(value_year$value_index)
  #calculate mean for each year seperately
  mean_index <-  aggregate(value_index~begin_year, value_year, mean )
  #Rename column
  mean_index$average_year <- mean_index$value_index
  
  #match to two columns with different length by machting criteria
  tamboraData$mean <- mean_index[match(tamboraData$begin_year, mean_index$begin_year), 'average_year']

  ggplot(aes(y = value_index, x = begin_year), data = tamboraData, x)+ 
    labs(fill= "Index", x = "Year", y = "Temperature Index", title = "")+
    geom_boxplot(aes(fill=mean, group = cut_width(begin_year, 1)), outlier.alpha = 0.1)+
    scale_y_continuous(breaks=c(-3,-2,-1,0,1,2,3))+
    scale_fill_gradient2(low="blue", mid="green", high="red", limits=c(-3,+3))+
    geom_jitter(size = 0.5,  width = 0.5, height = 0.25)+
    geom_smooth()
}
