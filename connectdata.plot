# SVG output
load "stats/terminal.include"

# title
set title "connectdata struct size" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Size in bytes"

set style line 1 \
    linecolor rgb '#0060ad' \
    linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set yrange [0:]

set xtics rotate 3600*24*365.25 nomirror
unset mxtics
set ytics nomirror

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot ARG1.'/connectdata.csv' using 2:3 with lines linestyle 1 title ""
