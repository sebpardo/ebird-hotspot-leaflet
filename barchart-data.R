# Description: Grabs eBird BarChart output (from website, to be done 
# through R in the future), and turns it into a LaTeX table with xtable

require(dplyr)
require(magrittr)
require(stringr)
require(readr)
require(xtable)

ebird <- read.delim("BarChart", skip=15, stringsAsFactors=F,
                  header=FALSE)

ebirdss <- read.delim("BarChart", skip=12, stringsAsFactors=F,
                      header=FALSE)

head(ebird)
str(ebird)
dim(ebird)

head(ebirdss)
sample.size <- as.numeric(ebirdss[2,-1])
zeros <- which(sample.size == 0)+1
zeros

# removing the last empty column
ebird %<>% select(-V50)

# renaming each column based on the four weeks within each month 
months <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
months4 <- rep(months, each=4)
week4 <- rep(1:4, 12)
colnames(ebird) <- c("Species",str_c(months4,week4))
#testing with tiny colnames


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

# Removing records between two similar species (looking for "/" string)
#ebird <- ebird[!(str_detect(ebird$Species, "/")),]

ebird[str_length(ebird$Species)>28,]

#test <- filter(ebird, Species== "American Goldfinch")

ebird2 <- ebird


# changing colnames to smaller values (doesn't matter anymore as
# xtable output doesn't include colnames & headers are specified in .tex file)
colnames(ebird2) <- c("Species", week4)

# transforming each proportion to an integer, so that:
# 0<0.1 -> 1, 0.1<0.2 -> 2, etc...
ebird2[,-1] <- ceiling(ebird[,-1]*10)

# replacing columns with zero observations with "u" so that image file
# shows lack of sampling

sum(ebird[,zeros])
sum(ebird2[,zeros])
ebird2[,zeros]<- "u"

# Replacing all values between 9 and 10 (0.9 and 1.0) with 9,
# s in eBird the full bar (size 9) is used for anything above 0.8
ebird2[ebird2 == 10] <- 9

# Replacing content of each cell with .png file according to integer value
# so that:
# "2" -> "\includegraphics{bars/s-2.png"}
for (i in seq_along(ebird2)[-1]) {
  ebird2[,i] <- paste0("\\includegraphics{bars/s-", ebird2[,i],".png}")
}

# Creating xtable object
sightchart <- xtable(ebird2)

# Exporting to .tex file
# Paste before \begin{tab...}
#   \tabcolsep=0.005cm
print.xtable(sightchart, file="bt.tex", 
             size = "tiny",
             tabular.environment = "longtable",
             #width = "9in",
             include.rownames = FALSE,
             include.colnames = FALSE,
             only.contents=TRUE,
             sanitize.text.function = function(x) {x})

