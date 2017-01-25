# needs devtools to install via github 
#
## install.packages("devtools", dependencies = TRUE)
## library("devtools")
install_github('tambora-org/tamboRapi')

# inquire data from collection 156: The Grotzfeld data set
data <- fromTambora("g[cid]=156")

# draw a map of all events
drawWorldMapAll(data)