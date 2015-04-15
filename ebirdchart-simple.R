# ebirdchart_()
#
# Simplified version of ebirdchart() which does not subset years
# or months.
#
# Function that reads hotspot-specific bar chart data through 
# the eBird website (no API). This allows for collecting summary
# hotspot data across all years rather than only from recent sightings.
#
# Author: Sebastian Pardo

ebirdchart_ <- function (locID) {
  if (missing(locID)) {
    stop("No location ID specified!")
  }
  cur.year <- as.numeric(format(Sys.Date(), "%Y"))
  if (cur.year < 2015) {
    cur.year <- 2015
  }
  chart.url <- paste0("http://ebird.org/ebird/BarChart?cmd=getChart&displayType=download&getLocations=hotspots&hotspots=",
        locID,
        "&bYear=1900&eYear=",
        cur.year,
        "&bMonth=1&eMonth=12&reportType=location&")
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
  
  return(list(n.taxa=n.taxa, 
              sample.size=sample.size,
              locID=locID,
              barchart=barchart))
}
