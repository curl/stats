# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Names listed in symbols-in-versions" font ",48"
# where's the legend
set key bottom right

# Identify the axes
#set xlabel "Time"
set ylabel "Number of symbols listed"

set style line 1 \
    linecolor rgb '#0060ad' \
    linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set yrange [0:]

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/symbols-over-time.csv' using 1:2 with lines linestyle 1 title ""
