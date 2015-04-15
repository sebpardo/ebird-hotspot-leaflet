# Description: Grabs eBird BarChart output (from website, to be done 
# through R in the future), and saves it as a LaTeX table with xtable()

require(dplyr)
require(stringr)
require(xtable)


# Loading data using ebirdchart() function
troutlake <- ebirdchart("L196159")
ebird <- troutlake$barchart
sample.size <- troutlake$sample.size

# removing text within parentheses for species name
ebird$Species <- str_replace(ebird$Species, " \\(.*\\)", "")

# Removing instances of records of Genus sp.
ebird <-ebird[!(str_detect(ebird$Species, "sp\\.")),]

# Removing hybrids (looking for " x " string)
ebird <- ebird[!(str_detect(ebird$Species, " x ")),]

# Removing records of two species together (looking for "/" string)
ebird <- ebird[!(str_detect(ebird$Species, "/")),]

# Finding common names longer than 28 characters
ebird[str_length(ebird$Species)>28,]

# Shortening really long common names has to be done by hand
ebird[ebird$Species=="Northern Rough-winged Swallow","Species"] <- "N. Rough-winged Swallow"

#test <- filter(ebird, Species== "American Goldfinch")

# Removing rare species, which for this filter are defined as species
# with observations in only one week (could still be multiple days
# within that week, or multiple observations in the same week but in
# different years)
notzeros <- apply(ebird[,-1],1, function (x) length(which(x != 0)))
lessone <- notzeros <= 1
rare <- ebird[lessone,"Species"]
ebird <- ebird[!lessone,]

# Saving all rare species in a single string
raresp <- paste(rare, collapse = ", ")
cat(raresp, file="raresp.txt")
                   
ebird2 <- ebird

# changing colnames to smaller values (doesn't matter anymore as
# xtable output doesn't include colnames & headers are specified in .tex file)
colnames(ebird2) <- c("Species", week4)

# transforming each proportion to an integer, so that:
# 0<0.1 -> 1, 0.1<0.2 -> 2, etc...
ebird2[,-1] <- ceiling(ebird[,-1]*10)

# replacing weeks with zero observations with "u" so that image file
# shows lack of sampling
ebird2[,zeros]<- "u"

# Replacing all values between 9 and 10 (0.9 and 1.0) with 9,
# as in eBird the full bar (size 9) is used for anything above 0.8
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
print.xtable(sightchart, file="bt.tex", 
             tabular.environment = "longtable",
             include.rownames = FALSE,
             include.colnames = FALSE,
             only.contents=TRUE,
             sanitize.text.function = function(x) {x})
