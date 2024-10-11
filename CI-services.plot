# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "CI services" font ",48"
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

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/CI.csv' using 1:4 with lines lw 3 title "Cirrus CI", \
 'tmp/CI.csv' using 1:5 with lines lw 3 title "Appveyor", \
 'tmp/CI.csv' using 1:6 with lines lw 3 title "Azure Pipelines", \
 'tmp/CI.csv' using 1:7 with lines lw 3 title "Github Actions", \
 'tmp/CI.csv' using 1:8 with lines lw 3 title "Circle CI", \
 'tmp/CI.csv' using 1:9 with lines lw 3 title "Zuul CI", \
 'tmp/CI.csv' using 1:3 with lines lw 3 title "Travis CI"
