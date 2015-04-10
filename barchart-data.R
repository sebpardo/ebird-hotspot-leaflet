require(dplyr)
require(magrittr)
require(stringr)
require(readr)
require(xtable)

ebird <- read.delim("BarChart", skip=15, stringsAsFactors=F,
                  header=FALSE)
head(ebird)
str(ebird)
dim(ebird)

# removing the last empty column
ebird %<>% select(-V50)

# renaming each column based on the four weeks within each month 
months <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
months4 <- rep(months, each=4)
week4 <- rep(1:4, 12)
colnames(ebird) <- c("Species",str_c(months4,week4))

# transforming all values of proportional abundance as numeric
ebird[,-1] <- apply(ebird[,-1],2,as.numeric)
str(ebird)

# removing text within parentheses for species name
ebird$Species <- str_replace(ebird$Species, " \\(.*\\)", "")
str(ebird)

# Removing instances of records of Genus sp.
ebird <-ebird[!(str_detect(ebird$Species, "sp\\.")),]
dim(ebird)
ebird$Species

# Removing hybrids (looking for " x " string)
#ebird <- ebird[!(str_detect(ebird$Species, " x ")),]

xtable(ebird)

filter(ebird, Species== "American Goldfinch")
