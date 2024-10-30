# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Production source code age\n{/*0.4X percent of the code is younger than this}" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Age in years"

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set yrange [0:]
#set xrange ["2005-10-01":]

set xtics rotate 3600*24*365.25 nomirror out
unset mxtics
set ytics out

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/codeage.csv' using 1:2 with filledcurves above title "P90", \
 'tmp/codeage.csv' using 1:3 with filledcurves above title "P80", \
 'tmp/codeage.csv' using 1:4 with filledcurves above title "P70", \
 'tmp/codeage.csv' using 1:5 with filledcurves above title "P60", \
 'tmp/codeage.csv' using 1:6 with filledcurves above title "Median", \
 'tmp/codeage.csv' using 1:7 with filledcurves above title "P40", \
 'tmp/codeage.csv' using 1:8 with filledcurves above title "P30", \
 'tmp/codeage.csv' using 1:9 with filledcurves above title "P20", \
 'tmp/codeage.csv' using 1:10 with filledcurves above title "P10", \
 'tmp/codeage.csv' using 1:11 with filledcurves above title "P5"
