# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Total number of CI jobs" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of CI jobs"

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xrange ["2013-08-01":]

if (!exists("logo")) logo="stats/curl-symbol-light.png"
set pixmap 1 logo
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/CI.csv' using 1:2 with lines lw 4 title ""
