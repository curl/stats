# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Severity distribution among all curl vulnerability reports accumulated" font ",48"
# where's the legend
set key top left opaque

# Identify the axes
set ylabel "Share of all reports at the time"

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate 3600*24*365.25 nomirror out
set ytics out
unset mxtics

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.62, 0.15 width screen 0.30

set yrange [0:100]

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot \
'tmp/severity.csv' using 1:5 with filledcurves above fc "#fe0000" title "critical", \
'tmp/severity.csv' using 1:4 with filledcurves above fc "#800000" title "high", \
'tmp/severity.csv' using 1:3 with filledcurves above fc "#0080c0" title "medium", \
'tmp/severity.csv' using 1:2 with filledcurves above fc "#2e8a00" title "low"
