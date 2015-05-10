LL = eleaflet



all: leaflet

leaflet: bt.tex
	pdflatex $(LL).tex

table: bt.tex

bt.tex: barchart-data.R 
	Rscript $^

thumbs: bars/b1.gif
	gif2png bars/*.gif
	convert bars/b*.png -thumbnail x9 -unsharp 0 bars/s.png
	convert bars/bu.png -resize x9 bars/s-u.png
	#cp bars/s-10.png bars/s-u.png

thumbs2: bars/b1.gif
	convert bars/b*.gif -thumbnail 3 -unsharp 0 bars/s.png
	convert bars/bu.gif -thumbnail 3 -unsharp 0 bars/s-u.png
	#cp bars/s-10.png bars/s-u.png
