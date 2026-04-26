# SVG output
load "stats/terminal.include"

# title
set title "Graphs in the curl dashboard\n{/*0.4Yes, it includes this one}" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of graphs"

set style line 1 \
    linecolor rgb '#a0202d' \
    linetype 1 linewidth 3

set style line 2 \
    linecolor rgb '#40c02d' \
    linewidth 3

set grid
unset border
set xtics autofreq nomirror
set ytics nomirror
unset mxtics

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# start Y at 0
set xrange ["2020-01-01":]
set yrange [0:]

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot  ARG1.'/graphs.csv' using 1:3 with lines linestyle 2 title "Individual plots", \
ARG1.'/graphs.csv' using 1:2 with lines linestyle 1 title "Graphs (images)"

