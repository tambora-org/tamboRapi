# needs devtools to install via github 
## if (!require("devtools")) install.packages("devtools")
## library("devtools")
devtools::install_github('tambora-org/tamboRapi')

# inquire data from collection 156: The Grotzfeld data set
data <- tamboRapi::fromTambora("g[cid]=156")

# draw a map of all events
tamboRapi::drawWorldMapAll(data)