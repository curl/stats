# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Monthly first time authors" font ",48"
# where's the legend
set key top left

# Identify the axes
set xlabel "Time"
set ylabel "Authors"

set style line 1 \
    linecolor rgb '#c0c0ff' \
    linetype 1 linewidth 2

set style line 2 \
    linecolor rgb '#ff60ad' \
    dt 1 linewidth 4

set grid

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/firsttimers.csv' using 1:3 with lines linestyle 2 title "12 month average", \
 'tmp/firsttimers.csv' using 1:2 with lines linestyle 1 title "First timers"
