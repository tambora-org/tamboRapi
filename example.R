# needs devtools to install via github 
#
## install.packages("devtools")
## library("devtools")
install_github('tamboRapi','tambora-org')

# inquire data from collection 156: The Grotzfeld data set
data <- fromTambora("g[cid]=156")

# draw a map of all events
drawWorldMapAll(data)