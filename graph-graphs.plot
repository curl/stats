# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Number of graphs showing number of graphs on the dashboard" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "Number of graph graphs"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 7 linewidth 4 \
    pointtype 6

set grid
set yrange [0:2]
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set ytics 1
set xtics nomirror rotate

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%b %Y"
set datafile separator ";"
plot 'tmp/graph-graphs.csv' using 1:2 with steps linestyle 1 title ""
