# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Items listed in TODO and KNOWN BUGS" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of items listed"

set style line 1 \
    linecolor rgb '#0060ad' \
    linewidth 4
set style line 2 \
    linecolor rgb '#40c040' \
    linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set yrange [0:]
#set xrange ["2010-01-01":]

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/todo-over-time.csv' using 1:3 with lines linestyle 1 title "KNOWN BUGS", \
 'tmp/todo-over-time.csv' using 1:2 with lines linestyle 2 title "TODO"
