### LaTeX template to create bird checklist leaflet from eBird data

This code attempts to create a leaflet document type in LateX using
[eBird](http://www.ebird.org) hotspot data. For this example I'll be 
using the [Vancouver--Trout Lake (John Hendry Park)](http://ebird.org/ebird/canada/GuideMe?cmd=decisionPage&getLocations=hotspots&hotspots=L196159&yr=all&m=) hotspot.

The first part of the process consists of wrangling the output `csv` file
into a format that can be imported in LaTex using [R](http://r-project.org).
Then the file with eBird data gets turned into a LaTeX table to be added to
the leaflet .tex file.


