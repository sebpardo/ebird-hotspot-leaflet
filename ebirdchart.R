# ebirdchart()
#
# Function that reads hotspot-specific bar chart data through 
# the eBird website (no API). This allows for collecting summary
# hotspot data across all years rather than only from recent sightings.
# Also allows for subsetting years, or month ranges.
#
# Author: Sebastian Pardo

ebirdchart <- function (locID, bYear=1900, eYear=format(Sys.Date(), "%Y"), 
                        bMonth=1, eMonth=12) {

  if (missing(locID)) {
    stop("No location ID specified!")
  }

  if(length(locID) > 1) {
    stop("'locID' length is greater than 1")
  }  
  if (bMonth > eMonth) {
    stop("Starting month specified is after ending month")
  }

  chart.url <- paste0("http://ebird.org/ebird/BarChart?cmd=getChart&displayType=download&getLocations=hotspots&hotspots=",
        locID,
        "&bYear=",
        bYear,
        "&eYear=",
        eYear,
        "&bMonth=",
        bMonth,
        "&eMonth=",
        eMonth,
        "&reportType=location&")
  hotspot.chart <- read.delim(chart.url, stringsAsFactors=F, header=FALSE)
  
  # wrangling data frame
  hotspot.chart <- hotspot.chart[,-50]
  n.taxa <- as.numeric(hotspot.chart[2,2])
  if(n.taxa == 0) {
    stop(paste0("Hotspot '",locID,"' doesn't exist or has no sightings"))
  }
  sample.size <- as.numeric(hotspot.chart[4,-1])
  barchart <- hotspot.chart[-(1:4),]
  barchart[,-1] <- apply(barchart[,-1],2,as.numeric)
  
  # adding colnames
  months4 <- rep(c("Jan","Feb","Mar","Apr","May","Jun",
              "Jul","Aug","Sep","Oct","Nov","Dec"), each=4)
  colnames(barchart) <- c("Species",paste0(months4, rep(1:4, 12)))
  names(sample.size) <- paste0(months4, rep(1:4, 12))
  
  nweeks <- (length(bMonth:eMonth)) * 4
  start.week <- ( (bMonth - 1) * 4) + 2
  end.week <- start.week + nweeks - 1
  col.weeks <- start.week:end.week
  
  return(list(n.taxa=n.taxa,
              sample.size=sample.size[col.weeks-1],
              locID=locID,
              barchart=barchart[,c(1,col.weeks)]))
}

# Examples of errors
# none <- ebirdchart()
# asd  <- ebirdchart("asdaasf")
# randh <- ebirdchart("L200000")
# trout <- ebirdchart(c("L196159","L199159"))
# 
# trout <- ebirdchart("L196159") # Trout Lake, Vancouver, BC
# trout$sample.size 
# 
# trout2014Jan <- ebirdchart("L196159", bYear=2014, eYear=2014, bMonth=1, eMonth=1)
# trout2014Jan$n.taxa
# trout2014Jan$sample.size
# head(trout2014Jan$barchart)

#iona <- ebirdchart("L124345") # Iona Island, BC, Canada
#iona$sample.size
#sacha <- ebirdchart("L882540") # Sacha Lodge, Ecuador
#sacha$n.taxa

#sacha$barchar$Species
#iona$barchart$Species
#str(iona)

