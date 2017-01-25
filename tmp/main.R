################################################
################################################
######MAIN SCRIPT
################################################
################################################

################################################
######PREAMBEL
################################################

######R-Packages

#ipak function: install and load multiple R packages.
ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

# define needed packages
packages <- c("jsonlite", "httr", "slam",  "png", "extrafont",  "wordcloud", "quanteda", "classInt", "ggmap", "ggplot2", "raster", "rgdal", "rgeos", "dplyr", "RColorBrewer", "topmodel", "lattice", "knitr", "sp", "plyr")
ipak(packages)

######Set local working directionary to define 

#On Windows use / as the path separator. Check Sys.info() to get informatioon about your OS

setwd("//geo.public.ads.uni-freiburg.de/Projekte/tambora/Data_Series/R_Figures") #E.g.

######define an output filename prefix

# all output files can than be found under this prefix
outputPrefix_index = "collection_156"

################################################
######READ DATA
################################################

######Link to Tambora.org's API

# set base url for loading data
urlBase <- "https://www.tambora.org/index.php/" 

# set string respectively the id of a public tambora.org collection 
searchString = "&g[cid]=156"

# define data-format as json and set limit per page 50 
urlSearch <- paste(urlBase, "grouping/event/json?limit=50", searchString, sep=""); 

# Load and iterate through data collection
nextPage <- 1
while(nextPage>0) {
  url <- paste(urlSearch, "&page=", nextPage, sep="");
  set_config( config( ssl_verifypeer = 0L ));
  #print(url);
  tmbEventsAll <- fromJSON(content(GET(url), "text"));
 # newEvents <- data.frame(t(sapply(tmbEventsAll$results,c)))
  newEvents <- tmbEventsAll$results
  if (nextPage==1) {
     tmbEvents <- newEvents;   
  } else {
    tmbEvents <- rbind(tmbEvents, newEvents);  
  };
  nextPage <- tmbEventsAll$nextPage;
  print(nextPage);
}

######Convert to a geodata-file-format

#rename readed data
gps_in <- tmbEvents  

#define columns for coordinates
class(gps_in) 
coordinates(gps_in)<-~longitude+latitude 

#define projection and datum
proj4string(gps_in)<-CRS(" +init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 ")
gps_in<-data.frame(gps_in)
names(gps_in)[names(gps_in)=="longitude"]<-"x"
names(gps_in)[names(gps_in)=="latitude"]<-"y"

################################################
######RUN FUNCTIONS
################################################

######Draw Maps
source("//geo.public.ads.uni-freiburg.de/Projekte/tambora/Daten/R/Scripts/worldmap.r")

######Plot
source("//geo.public.ads.uni-freiburg.de/Projekte/tambora/Daten/R/Scripts/coding_level_2.r")







