# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Commits" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of commits"

set style line 1 \
    linecolor rgb '#40c0ad' \
    linetype 1 linewidth 2
set style line 2 \
    linecolor rgb '#c04040' \
    linewidth 2
set style line 3 \
    linecolor rgb '#4040c0' \
    linewidth 2

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate 3600*24*365.25 nomirror out
unset mxtics
set ytics nomirror

load "stats/config.plot"



# set the format of the dates on the x axis
set format x "%Y"
set format y "%.0s%c"
set datafile separator ";"
plot'tmp/commits-over-time.csv' using 1:3 with lines linestyle 2 title "Daniel's commits", \
  'tmp/commits-over-time.csv' using 1:4 with lines linestyle 3 title "Everyone else's commits", \
  'tmp/commits-over-time.csv' using 1:2 with lines linestyle 1 title "All commits"
