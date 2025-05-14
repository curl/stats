# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "CI jobs per platform" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of jobs"

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

load "stats/config.plot"

# set the format of the dates on the x axis
set format x "%b %Y"
set datafile separator ";"

plot 'tmp/CI-platforms.csv' using 1:3 with lines lw 3 title "Linux", \
 'tmp/CI-platforms.csv' using 1:4 with lines lw 3 title "macOS", \
 'tmp/CI-platforms.csv' using 1:5 with lines lw 3 title "Windows", \
 'tmp/CI-platforms.csv' using 1:6 with lines lw 3 title "FreeBSD"
