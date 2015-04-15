### ebirdchart(): R function to download eBird Hotspot Explorer data (and LaTeX template to make a leaflet with it)

This code  provides the [`ebirdchart`](ebirdchart.R) function for [R](http://r-project.org) which downloads the bar chart
data provided by [eBird](http://www.ebird.org) though their website. The function `ebirdchart` does not query eBird's API
interface the way the functions in [`rebird`](https://github.com/ropensci/rebird) do; instead it uses 
the URL-based interface in eBird's [Hotspot Explorer](http://ebird.org/ebird/hotspots) details pages (example [here](http://ebird.org/ebird/canada/GuideMe?cmd=decisionPage&getLocations=hotspots&hotspots=L196159&yr=all&m=)). 

This repository also provides code to manipulates the output from `ebirchart` to create a leaflet template in LaTeX
without having to fuss over about formatting a LaTeX table into it.

As an example I use the [Vancouver--Trout Lake (John Hendry Park)](http://ebird.org/ebird/canada/GuideMe?cmd=decisionPage&getLocations=hotspots&hotspots=L196159&yr=all&m=) hotspot.

The basic workflow is as follows (R code [here](barchart-data.R)):

1. Downloading the eBird sightings data and make it a workable data frame using the `ebirdchart` function in R (example of raw data provided by eBird [here](BarChart)).
2. Deleting records that are not specific of a given species, such as hybrids (e.g. Western x Glaucous-winged Gull), those of potentially two similar species (e.g. Greater/Lesser Scaup), as well as those which cover a genus or broad taxonomic group. (e.g. *Empidonax* sp.). 
3. Identifying any really long common names so that they can be abbreviated (in Trout Lake only one was changing Northern Rough-winged Swallow to N. Rough-winged Swallow).
4. Removing all rare species from the data frame. The definition of rare here is any species which only has records for a single week. This
does encompass records across multiple days and years, if they occur within a single week. The rare species list is then exported as a character string.
4. Convert the proportion of times sighted for each species on a given week to an integer value.
5. Replace the integer value in each cell with its respective bar image, so that higher values show larger bars.
6. Export data frame as a LaTeX [table](bt.tex) using the [`xtable`](http://cran.r-project.org/web/packages/xtable/index.html) package and rare species list.
7. Add the output created in step 6 to a LaTeX [document](eleaflet.tex) of class [`leaflet`](http://www.ctan.org/tex-archive/macros/latex/contrib/leaflet/). 

**[The leaflet so far](eleaflet.pdf)**
