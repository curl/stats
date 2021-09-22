# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Graphs in the dashboard" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of graphs and plots"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 4

set style line 2 \
    linecolor rgb '#40e02d' \
    dt 1 linewidth 4

set grid
unset border
set xtics nomirror
set ytics nomirror 10
unset mxtics

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# start Y at 0
#set yrange [0:]

# set the format of the dates on the x axis
set format x "%b %Y"
set datafile separator ";"
plot  'tmp/graphs.csv' using 1:2 with steps linestyle 1 title "Separate images",\
 'tmp/graphs.csv' using 1:3 with steps linestyle 2 title "Individual plots"

