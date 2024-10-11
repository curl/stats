# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "curl releases per year" font ",48"
# where's the legend
set key top center

# Identify the axes
#set xlabel "Years"
#set ylabel "Number of releases"
#set grid ytics mytics
unset border

# for the boxes
set boxwidth 0.9 relative
set style fill solid

#set grid ytics

#set mytics 5

# time formated using this format
set timefmt "%Y"
set xdata time
set xtics rotate 3600*24*365.25 nomirror in
unset mxtics
unset ytics

set yrange [0:]

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"

plot 'tmp/releases-per-year.csv' using 1:2 with boxes title "" fc '#a0a000', \
 'tmp/releases-per-year.csv' using 1:3 with lines title "5 year average" lw 4, \
 'tmp/releases-per-year.csv' using 1:4 with lines title "All-time average" lw 4, \
 'tmp/releases-per-year.csv' using 1:2:2 with labels title "" offset 0,.5 font ", 24" tc lt 1
