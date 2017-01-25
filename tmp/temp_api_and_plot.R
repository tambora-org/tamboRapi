# ipak function: install and load multiple R packages.
# check to see if packages are installed. Install them if they are not, then load them into the R session.

ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

# usage
packages <- c("jsonlite", "httr")
ipak(packages)
urlBase <- "https://www.tambora.org/index.php/" 
searchString = "&g[cid]=206"
urlSearch <- paste(urlBase, "grouping/event/json?limit=45", searchString, sep=""); 

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



##########################################
# Draw World Map
########################################## 
gps_in <- tmbEvents  
#gps_in <- data.frame(t(sapply(gps_in,c)))


# usage
packages <- c("slam",  "png", "extrafont",  "wordcloud", "quanteda", "classInt", "ggmap", "ggplot2", "raster", "rgdal", "rgeos", "dplyr", "RColorBrewer", "topmodel", "lattice", "knitr", "sp", "plyr")
ipak(packages)

class(gps_in) 
coordinates(gps_in)<-~longitude+latitude 
proj4string(gps_in)<-CRS(" +init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 ")
gps_in<-data.frame(gps_in)
names(gps_in)[names(gps_in)=="longitude"]<-"x"
names(gps_in)[names(gps_in)=="latitude"]<-"y"

#make a bounding box based on input data
bbox <- make_bbox(lon = gps_in$x, lat = gps_in$y, f = 0.05)

mp <- NULL
mapWorld <- borders("world", colour="#6F9BC5", fill="#6F9BC5") # create a layer of borders
mp <- ggplot() +   mapWorld

#Now Layer the Events on top
mp <- mp+ geom_point(aes(x=gps_in$x, y=gps_in$y) ,color="#F08219", size=2, shape=20)+
  labs(fill="")+
  theme(legend.position="right", text=element_text(size=14, family="Calibri")) 
mp  


#########################################################################
###Plot Top 10 Content Related Coding // NODE_LABEL
#########################################################################

one_percent <- nrow(gps_in)/100

node_label <- data.frame(t(sort((table(gps_in$node_label)/one_percent), decreasing = TRUE)))

names(node_label) <- chartr(".", " ", names(node_label))

node_label$`not coded` <- NULL

col = min(10,ncol(node_label))

nodes <- node_label[,1:col]

nodes_ten <- data.frame(t(nodes))

nodes_ten <- setNames(cbind(rownames(nodes_ten), nodes_ten, row.names = NULL), 
                      c("label", "percent"))

nodes_ten$label <- as.character(nodes_ten$label)

nodes_ten$label <- factor(nodes_ten$label, levels=unique(nodes_ten$label))

#Load fonts
#font_import()# import all your fonts
loadfonts(device = "win")
windowsFonts(Calibri=windowsFont("Calibri"))

cairo_pdf("result/ibn_tawg_content.pdf", height=4, width=8, family="Calibri")

d <- ggplot(nodes_ten, aes(nodes_ten$label, nodes_ten$percent))

d + geom_col(color="#6F9BC5", fill="#6F9BC5")+
  labs(x="Codes", y="%", fill="")+
  theme(legend.position="right", axis.text.x = element_text(angle = 90, hjust = 1), text=element_text(size=14, family="Calibri"))

dev.off() 



#########################################################################
###Plot Top 10 Content Related Coding // PATH 2. SEGMENT
#########################################################################
allpath <- paste(gps_in$path,gps_in$node_label, sep="/")

# split the first column by '_' character to 
idSplitter = strsplit(as.character(allpath),'/')


# helpfunction to return a given element from a vector
get <- function(v, x){
  return( v[x] )
}

# separate relevant degree levels
deep_1= unlist(lapply(idSplitter, get, 1))
deep_2= unlist(lapply(idSplitter, get, 2))

# deep <- lengths(idSplitter)

deep_ten <- data.frame(t(deep_2))

one_percent <- nrow(gps_in)/100

deep_label <- data.frame(t(sort((table(unlist(deep_2))/one_percent), decreasing = TRUE)))

col = min(10,ncol(deep_label))

deep <- deep_label[,1:col]

deep_ten <- data.frame(t(deep))

deep_ten <- setNames(cbind(rownames(deep_ten), deep_ten, row.names = NULL), 
                      c("label", "percent"))

deep_ten$label <- as.character(deep_ten$label)

deep_ten$label <- factor(deep_ten$label, levels=unique(deep_ten$label))

#Load fonts
#font_import()# import all your fonts
loadfonts(device = "win")
windowsFonts(Calibri=windowsFont("Calibri"))

cairo_pdf("result/ibn_tawg_content.pdf", height=4, width=8, family="Calibri")

d <- ggplot(deep_ten, aes(deep_ten$label, deep_ten$percent))

d + geom_col(color="#6F9BC5", fill="#6F9BC5")+
  labs(x="Codes", y="%", fill="")+
  theme(legend.position="right", axis.text.x = element_text(angle = 90, hjust = 1), text=element_text(size=14, family="Calibri"))

dev.off() 























##########################################
########################################## 
##########################################
########################################## 

#########################################################################
###Getting started
########################################################################

#Set Working Directionary
setwd("//geo.public.ads.uni-freiburg.de/Projekte/tambora/Daten/Orient/R_Scripting")


# ipak function: install and load multiple R packages.
# check to see if packages are installed. Install them if they are not, then load them into the R session.

ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

# usage
packages <- c("slam",  "png", "extrafont",  "wordcloud", "quanteda", "classInt", "ggmap", "ggplot2", "raster", "rgdal", "rgeos", "dplyr", "RColorBrewer", "topmodel", "lattice", "knitr", "sp")
ipak(packages)


#########################################################################
###READ DATA
#########################################################################
# define an input file here (relative to the working folder from which this script is executed, or absolute)
inFile = "source/IbnTawqAll.csv"

# define an output filename prefix (all output files can than be found under this prefix)
outputPrefix_index = "result/ibn_tawq/"

gps_in <- read.table(inFile, encoding = "UTF-8", header=TRUE, sep=";", quote='"', na.strings="", dec='.')

# #### data integrity check

#check first entries
head(gps_in)

#overview statistics
summary(gps_in)

#########################################################################
###Convert to shp-file
#########################################################################

# data.frame
class(gps_in) 

# whatever the equivalent is in your data.frame
coordinates(gps_in)<-~longitude+latitude 

class(gps_in) # [1] "SpatialPointsDataFrame"
# attr(,"package")
# [1] "sp"

# does it have a projection/coordinate system assigned?
proj4string(gps_in) # nope
## [1] NA

# we know that the coordinate system is WGS 84 so we can manually
# tell R what the coordinate system is
proj4string(gps_in)<-CRS(" +init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 ")

# ggplot can't deal with a SpatialPointsDataFrame so we can convert back to a data.frame
gps_in<-data.frame(gps_in)

# we're not dealing with lat/long but with x/y
# this is not necessary but for clarity change variable names
names(gps_in)[names(gps_in)=="longitude"]<-"x"
names(gps_in)[names(gps_in)=="latitude"]<-"y"

#########################################################################
###Histograms
######################################################################

gps_in_location <- as.data.frame(table(gps_in$location_name))

colnames(gps_in_location) <- c("location_name","Frequency")

gps_in_location_order <- gps_in_location[order(-gps_in_location$Frequency),]

gps_in_30 <- gps_in_location_order[1:30,]

pdf("result/ibn_tawq_histogram_30locations.pdf")
ggplot(gps_in_30, aes(location_name, Frequency)) + geom_count(color = "#6F9BC5", fill = "#6F9BC5") + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
dev.off()

pdf("result/ibn_tawq_year_hist.pdf", height=2, width=8)
ggplot(gps_in, aes(year)) + geom_histogram( color = "#6F9BC5", fill = "#6F9BC5", binwidth = 0.5)
dev.off()

pdf("result/ibn_tawq_year_hist_0_2000.pdf", height=2, width=8)
ggplot(gps_in, aes(year)) + geom_histogram( color = "#6F9BC5", fill = "#6F9BC5", binwidth = 0.5)+
  scale_x_continuous(limits = c(0,2000), expand = c(0,0))
dev.off()

pdf("result/ibn_tawq_month_hist.pdf", height=2, width=8)
ggplot(gps_in, aes(month)) + geom_histogram( color = "#6F9BC5", fill = "#6F9BC5", binwidth = 0.5)+
  scale_x_continuous(breaks=c(1:12))
dev.off()


#########################################################################
###Homage to Michael
#########################################################################
#Load fonts
#font_import()# import all your fonts
loadfonts(device = "win")

windowsFonts(Calibri=windowsFont("Calibri"))


gps_in_time <- count(gps_in, year, month) 

month <- ggplot(gps_in_time, aes(year, month))


cairo_pdf("result/ibn_tawq_month_density.pdf", height=2, width=8, family="Calibri")
month + geom_raster(aes(fill=n))+
  scale_y_continuous(breaks=c(1,6,12))+
  theme(legend.position="right", text=element_text(size=14, family="Calibri"))+
  scale_fill_gradient(low="#8FABE5", high="#0F3B73")
dev.off() 

year <- ggplot(gps_in_time, aes(year, 0))

cairo_pdf("result/ibn_tawq_year_2000.pdf", height=2, width=8, family="Calibri")
year + geom_raster(aes(fill=n))+
  scale_x_continuous(limits = c(0,2000), expand = c(0,0))+
  scale_y_discrete()+
  labs(y="", fill="")+
  theme(legend.position="right", text=element_text(size=14, family="Calibri"))+
  scale_fill_gradient(low="#8FABE5", high="#0F3B73")
dev.off()  
  
#########################################################################
###create a Bounding Box
#########################################################################

#make a bounding box based on input data
bbox <- make_bbox(lon = gps_in$x, lat = gps_in$y, f = 0.05)


cairo_pdf("result/ibn_tawq_world.pdf", height=3, width=8, family="Calibri")
mp <- NULL
mapWorld <- borders("world", colour="#6F9BC5", fill="#6F9BC5") # create a layer of borders
mp <- ggplot() +   mapWorld

#Now Layer the Events on top
mp <- mp+ geom_point(aes(x=gps_in$x, y=gps_in$y) ,color="#F08219", size=2, shape=20)+
  labs( fill="")+
  theme(legend.position="right", text=element_text(size=14, family="Calibri")) 
mp
dev.off()


#########################################################################
###Create a pointmap with scaled shape size
#########################################################################
#Count No of same locations
gps_in_location_count <- count(gps_in, location_name, x, y) 

#Define Scale value
Number <- gps_in_location_count$n
Number_jenks <- classIntervals(Number, n = 10, sytle = "jenks")
b <- unique(Number_jenks$brks)
Breaks <- as.integer(b)


pdf("result/ibn_tawq_scaled_map.pdf")
map_bbox <- get_map(location = bbox, maptype = "watercolor", source = "stamen")
mapPoints_bbox <- ggmap(map_bbox)
mapPoints_bbox +
  geom_point(aes(x = x, y = y, size = Number), data = gps_in_location_count, shape=16, alpha = .35, stroke = 0, show.legend = FALSE) +
  scale_size_continuous(breaks=Breaks)

dev.off()

#########################################################################
###Create Damascus
#########################################################################
#Calculate the centroid of points(events) as average of lat/lon
center <- c(mean(gps_in$x), mean(gps_in$y))

pdf("result/ibn_tawq_center_map.pdf")
map_center <- get_map(location = center, zoom = 9, maptype = "watercolor", source = "stamen")
mapPoints_center <- ggmap(map_center)
mapPoints_center + 
  geom_point(aes(x = x, y = y, size = Number), data = gps_in_location_count, shape=16, alpha = .5, stroke = 0, show.legend = FALSE) +
  scale_size_continuous(breaks=Breaks)
dev.off()


#########################################################################
###Plot Top 10 Content Related Coding
#########################################################################

one_percent <- nrow(gps_in)/100

node_label <- data.frame(t(sort((table(gps_in$node_label)/one_percent), decreasing = TRUE)))

names(node_label) <- chartr(".", " ", names(node_label))

node_label$`not coded` <- NULL

nodes <- node_label[,1:10]

nodes_ten <- data.frame(t(nodes))

nodes_ten <- setNames(cbind(rownames(nodes_ten), nodes_ten, row.names = NULL), 
                      c("label", "percent"))

nodes_ten$label <- as.character(nodes_ten$label)

nodes_ten$label <- factor(nodes_ten$label, levels=unique(nodes_ten$label))


#Load fonts
#font_import()# import all your fonts
loadfonts(device = "win")
windowsFonts(Calibri=windowsFont("Calibri"))

cairo_pdf("result/ibn_tawg_content.pdf", height=4, width=8, family="Calibri")

d <- ggplot(nodes_ten, aes(nodes_ten$label, nodes_ten$percent))

d + geom_col(color="#6F9BC5", fill="#6F9BC5")+
  labs(x="Codes", y="%", fill="")+
  theme(legend.position="right", axis.text.x = element_text(angle = 90, hjust = 1), text=element_text(size=14, family="Calibri"))

dev.off() 




#####################
#####################
##END END END END
#####################
#####################








#########################################################################
###create a Wordcloud of coded events / quanteda
#########################################################################
install.packages('slam')

codes <- as.character(gps_in$node_label)

my_dfm <- dfm(codes)
plot(my_dfm)



  
  
  
  
  
