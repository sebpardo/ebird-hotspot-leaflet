# Description: Grabs eBird BarChart output (from website, to be done 
# through R in the future), and saves it as a LaTeX table with xtable()

require(dplyr)
require(stringr)
require(xtable)

source("ebirdchart.R")

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
ebird[str_length(ebird$Species)>28, 1]

# Shortening really long common names has to be done by hand
ebird[ebird$Species=="Northern Rough-winged Swallow","Species"] <- "N. Rough-winged Swallow"

#test <- filter(ebird, Species== "American Goldfinch")

# Removing rare species, which for this filter are defined as species
# with observations in only one week (could still be multiple days
# within that week, or multiple observations in the same week but in
# different years)

notzeros <- apply(ebird[,-1], 1, function (x) length(which(x != 0)))
lessone <- notzeros <= 1
rare <- ebird[lessone,"Species"]
ebird <- ebird[!lessone,]

# Saving all rare species in a single string
raresp <- paste0(paste(rare, collapse = ", "),".")
cat(raresp, file="raresp.txt")
                   
ebird2 <- ebird

# Transforming each proportion to a aspecific integer, 
# given range provided in bar_size(). This closely matches
# eBird's bar sizes which are much larger for smaller proportions
# than what would be expected if
# 0<0.1 -> 1, 0.1<0.2 -> 2, etc...

# Function that converts proportion numbers to bar size integer
# Vectorized to be applied to whole columns
bar_size <- function (x) {
  if(x == 0) "u" else
    if (x > 0 && x <= 0.01) 1 else
      if (x > 0.01 && x <= 0.02) 2 else
        if (x > 0.02 && x <= 0.05) 3 else
          if (x > 0.05 && x <= 0.1) 4 else
            if (x > 0.1 && x <= 0.2) 5 else
              if (x > 0.2 && x <= 0.3) 6 else
                if (x > 0.3 && x <= 0.4) 7 else
                  if (x > 0.4 && x <= 0.5) 8 else
                    if (x > 0.5) 9
}
barV <- Vectorize(bar_size)

ebird2[,-1] <- apply(ebird2[,-1],2,barV)

# Note that we replaced weeks with zero observations with "u" so that image file
# shows lack of sampling

# Replacing content of each cell with .png file according to integer value
# so that:
# "2" -> "\includegraphics{bars/s-2.png"}
for (i in seq_along(ebird2)[-1]) {
  ebird2[,i] <- paste0("\\includegraphics{bars/s-", ebird2[,i],".png}")
}

# Saving all rare species in a single string
qtime <- format(troutlake$query.time, "%B %d %Y at %I:%M %p %Z")
cat(paste("eBird database accessed on",qtime), file="qtime.txt") 

# Creating xtable object
sightchart <- xtable(ebird2)

# Exporting to .tex file
print.xtable(sightchart, file = "bt.tex", 
             tabular.environment = "longtable",
             include.rownames = FALSE,
             include.colnames = FALSE,
             only.contents = TRUE,
             hline.after = NULL,
             floating = FALSE,
             sanitize.text.function = function(x) {x})
