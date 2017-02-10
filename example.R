# needs devtools to install via github 
## if (!require("devtools")) install.packages("devtools")
## library("devtools")
devtools::install_github('tambora-org/tamboRapi')

# inquire data from collection 156: The Grotzfeld data set
data1 <- tamboRapi::fromTambora("g[cid]=156")
# draw a map of all events
tamboRapi::drawWorldMapAll(data1)

# inquire data with temperature level within timerange
data2 <- tamboRapi::fromTambora("c[sc]=1&t[yb]=1800&t[ye]=1830")
# draw a map of all events
tamboRapi::drawIndexBoxPlot(data2)
