# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Graphs in the curl dashboard" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of graphs and plots"

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
unset mxtics

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# start Y at 0
set yrange [0:]

# set the format of the dates on the x axis
set format x "%b %Y"
set datafile separator ";"
plot  'tmp/graphs.csv' using 1:2 with lines linestyle 1 title "Separate graphs",\
 'tmp/graphs.csv' using 1:3 with lines linestyle 2 title "Individual plots"

