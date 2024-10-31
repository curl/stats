# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Graphs in the curl dashboard" font ",48"
# where's the legend
set key top left horizontal

# Identify the axes
#set xlabel "Time"
set ylabel "Number of graphs"
set y2label "Number of individual plots"

set style line 1 \
    linecolor rgb '#a0202d' \
    linetype 1 linewidth 3

set style line 2 \
    linecolor rgb '#40c02d' \
    linewidth 3

set grid
unset border
set xtics nomirror
set ytics nomirror
set y2tics nomirror
unset mxtics

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# start Y at 0
set yrange [0:]

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%b %Y"
set datafile separator ";"
plot  'tmp/graphs.csv' using 1:2 with lines linestyle 1 title "Graphs",\
 'tmp/graphs.csv' using 1:3 with lines linestyle 2 axis x1y2 title "Plots"

