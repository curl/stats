# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Vulnerability distribution present in curl code" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "CVEs existing in the releas"

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

set xtics rotate 3600*24*365.25 nomirror out
#set mytics 5
set xrange ["1998-01-01":]
set yrange [0.1:]
#set mxtics 1

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"

plot \
'tmp/vuln-dist-code.csv' using 1:7 with filledcurves above fc "#2e8a00" title "low", \
'tmp/vuln-dist-code.csv' using 1:6 with filledcurves above fc "#0080c0" title "medium", \
'tmp/vuln-dist-code.csv' using 1:5 with filledcurves above fc "#800000" title "high", \
'tmp/vuln-dist-code.csv' using 1:4 with filledcurves above fc "#fe0000" title "critical"
