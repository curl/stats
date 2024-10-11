# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Vulnerabilities Fixed/Introduced" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Years"
set ylabel "CVEs reported within that year"

# for the boxes
set boxwidth 0.6 relative
set style fill solid 0.8

set style line 1 \
    linecolor rgb '#80ff00' \
    linetype 1 linewidth 3 \
    pointtype 7

set style line 2 \
    linecolor rgb '#ff8000' \
    linetype 1 linewidth 3 \
    pointtype 7

set grid ytics mytics
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

dayoffset = '90'

set xtics rotate 3600*24*365.25 nomirror out
set mytics 5
set xrange ["1998-01-01":]
set mxtics 1

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"

# plot the flaw periods and the project age with titles and line width 3
plot  'tmp/vulns-per-year.csv' using (strcol(1)[1:8].dayoffset):3 with boxes title "Introduced" fc '#800000', \
 'tmp/vulns-per-year.csv' using 1:2 with boxes title "Fixed" fc '#008000', \
 'tmp/vulns-per-year.csv' using 1:5 with lines linestyle 1 title "5 year average fixed", \
 'tmp/vulns-per-year.csv' using 1:6 with lines linestyle 2 title "5 year average introduced"
