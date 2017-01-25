################################################
################################################
######PLOT PERCENTAGE OF TOP 10 OR MIN NUMBER OF
######SECOND LEVEL CODES
################################################
################################################

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

deep_table <- table(unlist(deep_2))
deep_sorted <- t(sort((deep_table/one_percent), decreasing = TRUE))

deep_label <- data.frame(deep_sorted, check.names=F)

#deep_label <- data.frame(t(sort((table(unlist(deep_2))/one_percent), decreasing = TRUE)))

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

cairo_pdf("coding_level_2.pdf", height=4, width=8, family="Calibri")

d <- ggplot(deep_ten, aes(deep_ten$label, deep_ten$percent))

d + geom_col(color="#6F9BC5", fill="#6F9BC5")+
  labs(x="Codes", y="%", fill="")+
  theme(legend.position="right", axis.text.x = element_text(angle = 90, hjust = 1), text=element_text(size=14, family="Calibri"))

  dev.off() 