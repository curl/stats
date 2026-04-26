# SVG output
load "stats/terminal.include"

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

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%b %Y"
set datafile separator ";"

plot ARG1.'/CI-platforms.csv' using 1:3 with lines lw 3 title "Linux", \
 ARG1.'/CI-platforms.csv' using 1:4 with lines lw 3 title "macOS", \
 ARG1.'/CI-platforms.csv' using 1:5 with lines lw 3 title "Windows", \
 ARG1.'/CI-platforms.csv' using 1:6 with lines lw 3 title "FreeBSD"
