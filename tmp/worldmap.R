################################################
################################################
######WORLD MAP
################################################
################################################

#make a bounding box based on input data
bbox <- make_bbox(lon = gps_in$x, lat = gps_in$y, f = 0.05)

# create a layer of borders
mp <- NULL
mapWorld <- borders("world", colour="#6F9BC5", fill="#6F9BC5")
mp <- ggplot() +   mapWorld

#plot now layer of events on top
mp <- mp+ geom_point(aes(x=gps_in$x, y=gps_in$y) ,color="#F08219", size=2, shape=20)+
  labs(fill="")+
  theme(legend.position="right", text=element_text(size=14, family="Calibri")) 
mp  