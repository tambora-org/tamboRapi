source("R/tmbImportPackages.R")

installDrawPackages <- function() {
  # define needed packages
  packages <- c("extrafont", "plyr", "ggplot2")
  tmbImportPackages(packages)
}

#' Draw density of all tambora data to month and year 
#'
#' This function allows you to draw data inquired from tambora.org to a map
#' @param tamboraData, i.e. as inquired by function fromTambora()
#' @keywords tambora.org map visualisation
#' @export
#' @examples
#' data<-fromTambora(); drawWorldMapAll(data)

drawYearMonthDensity <- function(tamboraData) {
  installDrawPackages()
  
  data_time <- count(data, c("begin_year", "begin_month_id")) 
  data_time <- data_time[complete.cases(data_time ),]
  mean_year <- mean(data_time$begin_year, na.rm=TRUE)
  sd_year <- sd(data_time$begin_year, na.rm=TRUE)
  year_scale <- c(mean_year-1*sd_year, mean_year+1*sd_year )
  data_time <- subset(data_time, begin_year>mean_year-1*sd_year & begin_year<mean_year+1*sd_year )

mp <- ggplot(data_time, aes(begin_year, begin_month_id))

mp + geom_raster(aes(fill=n))+
  scale_y_continuous(breaks=c(1,6,12))+
  theme(panel.background = element_rect(fill = '#EEEEEE', colour = 'white'), legend.position="right", text=element_text(size=14, family="Calibri"))+
  scale_fill_gradient(low="#8FABE5", high="#0F3B73")
  #+scale_x_continuous(limits = year_scale, expand = c(0,0))  
  
  
}
