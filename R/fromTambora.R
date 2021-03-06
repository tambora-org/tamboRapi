source("R/tmbImportPackages.R")

installJsonPackages <- function() {
  # define needed packages
  packages <- c("jsonlite", "httr", "sp")
  tmbImportPackages(packages)
}

defaultBaseUrl <- "https://www.tambora.org/index.php/" 
# set string respectively the id of a public tambora.org collection 
defaultSearchString = "g[cid]=58"

#' A tambora.org inquire function
#'
#' This function allows you to fetch data from tambora.org
#' @param searchString defines the properties to search for, i.e. 'g[cid]=58'
#' @param userEmail defines the email of the user account to use permissions
#' @param userToken defines the secret token of the user account to use permissions
#' @param baseUrl defines the instance of tambora to search from Defaults to 'https://www.tambora.org/index.php/'
#' @keywords tambora cre api climatology
#' @export
#' @examples
#' fromTambora()

fromTambora <- function(searchString, userEmail, userToken, baseUrl) {
  installJsonPackages()
  if(missing(searchString)) {
     searchString <- defaultSearchString
  }
  if(missing(baseUrl)) {
     baseUrl <- defaultBaseUrl
  }

  # define data-format as json and set limit per page 50 
  urlSearch <- paste(baseUrl, "grouping/event/json?limit=50&", searchString, sep=""); 
  
  writeLines("Inquiring data from tambora.org:");
  writeLines("+----+----+----+----+----+----+----+----+----+----+");  
  # get chunks of 50 untill nothing is left...
nextPage <- 1
while(nextPage>0) {
    url <- paste(urlSearch, "&page=", nextPage, sep="");
    set_config( config( ssl_verifypeer = 0L ));
    #print(url);
    tmbEventsAll <- fromJSON(content(GET(url), type="text", encoding="UTF-8"));
    tmbEventsAll[ is.na(tmbEventsAll) ] <- NA; 
    newEvents <- tmbEventsAll$results
    if (nextPage==1) {
       tamboraData <- newEvents;   
    } else {
      tamboraData <- rbind(tamboraData, newEvents);  
    };
    deltaFactor <- 50 * strtoi(tmbEventsAll$limit) / strtoi(tmbEventsAll$total);
    deltaMarks <- round(nextPage*deltaFactor) - round((nextPage-1)*deltaFactor)
    writeLines(substr('oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo', 0, deltaMarks), sep = ""); 
    nextPage <- tmbEventsAll$nextPage; 
  }
  writeLines('o\nFinished'); 
  class(tamboraData) 
  coordinates(tamboraData)<-~longitude+latitude 

  #define projection and datum
  proj4string(tamboraData)<-CRS(" +init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 ")
  tamboraData<-data.frame(tamboraData)
  names(tamboraData)[names(tamboraData)=="longitude"]<-"x"
  names(tamboraData)[names(tamboraData)=="latitude"]<-"y"

  # return value
  tamboraData 
}






