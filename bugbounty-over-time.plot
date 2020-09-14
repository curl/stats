# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Accumulated curl bug-bounty payouts" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "USD"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 7 linewidth 3

# for the boxes
set boxwidth 10 relative
set style fill solid

set grid

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# start Y at 0
set yrange [0:]

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/bugbounty-over-time.csv' using 2:3 with linespoints linestyle 1 title ""
