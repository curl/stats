# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Daniel's share of the total commits" font ",48"
# where's the legend
set key bottom right

# Identify the axes
set xlabel "Time"
set ylabel "Percentage of git commits"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 4 
set style line 2 \
    linecolor rgb '#40c040' \
    linetype 3 linewidth 3

set grid

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set yrange [0:]

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/daniel-vs-rest.csv' using 1:3 with lines linestyle 1 title "Daniel", \
 'tmp/daniel-vs-rest.csv' using 1:4 with lines linestyle 2 title "Everyone else"
