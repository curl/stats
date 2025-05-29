# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Complexity distribution\n{/*0.4How big share of the source code is considered how complex}" font ",48"
# where's the legend
set key bottom left opaque

# Identify the axes
#set xlabel "Time"
set ylabel "Percentage share of the product code"

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate 3600*24*365.25 nomirror out
set ytics out
unset mxtics

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.15 width screen 0.30

set yrange [0:]

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/complex-dist.csv' using 1:7 with filledcurves above fc "#fe0000" title "above 200", \
 'tmp/complex-dist.csv' using 1:6 with filledcurves above fc "#001280" title "up to 200", \
 'tmp/complex-dist.csv' using 1:5 with filledcurves above fc "#ffd800" title "up to 100", \
 'tmp/complex-dist.csv' using 1:4 with filledcurves above fc "#007f0e" title "up to 75", \
 'tmp/complex-dist.csv' using 1:3 with filledcurves above fc "#0094fe" title "up to 50", \
 'tmp/complex-dist.csv' using 1:2 with filledcurves above fc "#b100fe" title "up to 15"
