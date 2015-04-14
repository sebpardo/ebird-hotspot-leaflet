### LaTeX template to create bird checklist leaflet from eBird data

This code attempts to create a leaflet document type in LateX using
[eBird](http://www.ebird.org) hotspot data. For this example I use 
the [Vancouver--Trout Lake (John Hendry Park)](http://ebird.org/ebird/canada/GuideMe?cmd=decisionPage&getLocations=hotspots&hotspots=L196159&yr=all&m=) hotspot.

The first part of the process consists of wrangling the output tab-delimited [file](BarChart)
using [R](http://r-project.org) and exporting it as a LaTeX [table](bt.tex) using the [`xtable`](http://cran.r-project.org/web/packages/xtable/index.html) package. 
This table is then added into a LaTeX [document](http://www.ctan.org/tex-archive/macros/latex/contrib/leaflet/) of class `leaflet`. 

The basic data wrangling works as follows (code [here](barchart-data.R)):

1. Fitting the eBird sightings data into a workable dataframe in R. 
2. Deleting records that are not specific of a given species, such as hybrids (e.g. Western x Glaucous-winged Gull), those of potentially two similar species (e.g. Greater/Lesser Scaup), as well as those which cover a genus or broad taxonomic group. (e.g. *Empidonax* sp.). 
3. Identifying any really long common names so that they can be abbreviated (in Trout Lake only one was changing Northern Rough-winged Swallow to N. Rough-winged Swallow).
4. Convert the proportion of times sighted for each species on a given week to an integer value.
5. Replace the integer value in each cell with its respective bar image, so that higher values show larger bars.
6. Export data frame as a LaTeX table, and compile it within the leaflet template.

**[The leaflet so far](eleaflet.pdf)**
