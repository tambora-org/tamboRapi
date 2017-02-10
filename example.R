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
# draw a box plot for indices
tamboRapi::drawIndexBoxPlot(data2)

# inquire data for solar eclipses within europe
data3 <- tamboRapi::fromTambora("c[nd]=315&s[lt1]=33.28&s[lg1]=-7.73&s[lt2]=61.10&s[lg2]=26.54")
# draw a histogramm across the years
tamboRapi::drawYearHistogramm(data3)
